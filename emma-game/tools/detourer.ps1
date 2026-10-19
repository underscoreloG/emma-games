param(
    [string]$InFile,
    [string]$OutFile,
    [int]$BrightMin = 200,
    [int]$SatMax = 30,
    [int]$MaxSize = 600   # plus grand cote en px (le jeu affiche ~300 px)
)
$ErrorActionPreference = "Stop"
# Chemins absolus : le code C# ne connait pas le dossier courant de PowerShell
$InFile = (Resolve-Path $InFile).Path
$OutFile = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutFile)

Add-Type -ReferencedAssemblies System.Drawing -TypeDefinition @"
using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Collections.Generic;

public static class BgRemover {
    // Flood-fill depuis les bords : rend transparents les pixels clairs peu satures
    // connectes au bord, puis recadre sur la zone opaque.
    public static int[] Clean(string inPath, string outPath, int brightMin, int satMax, int maxSize) {
        Bitmap src = new Bitmap(inPath);
        int w = src.Width, h = src.Height;
        Bitmap bmp = new Bitmap(w, h, PixelFormat.Format32bppArgb);
        using (Graphics g = Graphics.FromImage(bmp)) { g.DrawImage(src, 0, 0, w, h); }
        src.Dispose();

        Rectangle rect = new Rectangle(0, 0, w, h);
        BitmapData data = bmp.LockBits(rect, ImageLockMode.ReadWrite, PixelFormat.Format32bppArgb);
        int stride = data.Stride;
        int nbytes = Math.Abs(stride) * h;
        byte[] px = new byte[nbytes];
        System.Runtime.InteropServices.Marshal.Copy(data.Scan0, px, 0, nbytes);

        // Image deja transparente (PNG/WebP detoure) : on ne fait que recadrer
        int transparent = 0;
        for (int i = 3; i < nbytes; i += 4) { if (px[i] == 0) transparent++; }
        bool alreadyTransparent = transparent > (w * h) / 100;

        bool[] visited = new bool[w * h];
        Queue<int> q = new Queue<int>();

        Func<int, int, bool> isBg = delegate(int x, int y) {
            if (alreadyTransparent) return false;
            int i = y * stride + x * 4;
            int b = px[i]; int gg = px[i + 1]; int r = px[i + 2];
            int mx = Math.Max(r, Math.Max(gg, b));
            int mn = Math.Min(r, Math.Min(gg, b));
            return mx >= brightMin && (mx - mn) <= satMax;
        };

        for (int x = 0; x < w; x++) {
            int[] ys = { 0, h - 1 };
            foreach (int y in ys) {
                int id = y * w + x;
                if (!visited[id] && isBg(x, y)) { visited[id] = true; q.Enqueue(id); }
            }
        }
        for (int y = 0; y < h; y++) {
            int[] xs = { 0, w - 1 };
            foreach (int x in xs) {
                int id = y * w + x;
                if (!visited[id] && isBg(x, y)) { visited[id] = true; q.Enqueue(id); }
            }
        }

        int[] dx = { 1, -1, 0, 0 };
        int[] dy = { 0, 0, 1, -1 };
        while (q.Count > 0) {
            int idx = q.Dequeue();
            int x = idx % w, y = idx / w;
            px[y * stride + x * 4 + 3] = 0;
            for (int d = 0; d < 4; d++) {
                int nx = x + dx[d], ny = y + dy[d];
                if (nx < 0 || ny < 0 || nx >= w || ny >= h) continue;
                int ni = ny * w + nx;
                if (!visited[ni] && isBg(nx, ny)) { visited[ni] = true; q.Enqueue(ni); }
            }
        }

        System.Runtime.InteropServices.Marshal.Copy(px, 0, data.Scan0, nbytes);
        bmp.UnlockBits(data);

        // Recadrage sur la zone opaque
        int minX = w, minY = h, maxX = -1, maxY = -1;
        for (int y = 0; y < h; y++) {
            for (int x = 0; x < w; x++) {
                if (px[y * stride + x * 4 + 3] != 0) {
                    if (x < minX) minX = x;
                    if (x > maxX) maxX = x;
                    if (y < minY) minY = y;
                    if (y > maxY) maxY = y;
                }
            }
        }
        if (maxX < 0) { minX = 0; minY = 0; maxX = w - 1; maxY = h - 1; }
        int pad = 4;
        minX = Math.Max(0, minX - pad); minY = Math.Max(0, minY - pad);
        maxX = Math.Min(w - 1, maxX + pad); maxY = Math.Min(h - 1, maxY + pad);
        Rectangle crop = new Rectangle(minX, minY, maxX - minX + 1, maxY - minY + 1);
        Bitmap outBmp = bmp.Clone(crop, PixelFormat.Format32bppArgb);
        bmp.Dispose();

        // Reduction pour alleger le HTML (les images y sont en base64)
        int big = Math.Max(outBmp.Width, outBmp.Height);
        if (maxSize > 0 && big > maxSize) {
            double k = (double)maxSize / big;
            int nw = Math.Max(1, (int)Math.Round(outBmp.Width * k));
            int nh = Math.Max(1, (int)Math.Round(outBmp.Height * k));
            Bitmap small = new Bitmap(nw, nh, PixelFormat.Format32bppArgb);
            using (Graphics g = Graphics.FromImage(small)) {
                g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
                g.PixelOffsetMode = System.Drawing.Drawing2D.PixelOffsetMode.HighQuality;
                g.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality;
                g.DrawImage(outBmp, 0, 0, nw, nh);
            }
            outBmp.Dispose();
            outBmp = small;
        }
        outBmp.Save(outPath, ImageFormat.Png);
        int cw = outBmp.Width, ch = outBmp.Height;
        outBmp.Dispose();
        return new int[] { cw, ch };
    }
}
"@

# Le decodeur WebP de Windows perd la transparence : on passe par Edge/Chrome
$source = $InFile
if ([IO.Path]::GetExtension($InFile).ToLower() -eq ".webp") {
    $source = [IO.Path]::ChangeExtension($OutFile, ".src.png")
    & (Join-Path $PSScriptRoot "webp-en-png.ps1") -InFile $InFile -OutFile $source | Out-Null
}
try {
    $dims = [BgRemover]::Clean($source, $OutFile, $BrightMin, $SatMax, $MaxSize)
} finally {
    if ($source -ne $InFile) { Remove-Item $source -ErrorAction SilentlyContinue }
}
"{0} -> {1}x{2}, {3} KB" -f (Split-Path $InFile -Leaf), $dims[0], $dims[1], [math]::Round((Get-Item $OutFile).Length / 1KB)
