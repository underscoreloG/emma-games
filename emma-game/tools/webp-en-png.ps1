param(
    [Parameter(Mandatory = $true)][string]$InFile,
    [Parameter(Mandatory = $true)][string]$OutFile
)
# Convertit une image (WebP, etc.) en PNG en conservant la transparence,
# via Edge/Chrome headless (le decodeur WebP de Windows perd le canal alpha).
$ErrorActionPreference = "Stop"

$browser = @(
    "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
    "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
    "$env:ProgramFiles\Google\Chrome\Application\chrome.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $browser) { throw "Ni Edge ni Chrome trouve." }

$InFile = (Resolve-Path $InFile).Path
$ext = [IO.Path]::GetExtension($InFile).TrimStart(".").ToLower()
$mime = @{ webp = "image/webp"; png = "image/png"; jpg = "image/jpeg"; jpeg = "image/jpeg"; gif = "image/gif" }[$ext]
if (-not $mime) { throw "Format non gere : $ext" }
$b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($InFile))

# Image en data: URL pour ne pas "salir" le canvas (restriction cross-origin sur file://)
$page = @"
<!DOCTYPE html><html><body><pre id="out">EN_COURS</pre><script>
const img = new Image();
img.onload = () => {
  const c = document.createElement("canvas");
  c.width = img.naturalWidth; c.height = img.naturalHeight;
  c.getContext("2d").drawImage(img, 0, 0);
  document.getElementById("out").textContent = "OK:" + c.toDataURL("image/png");
};
img.onerror = () => { document.getElementById("out").textContent = "ERREUR_DECODAGE"; };
img.src = "data:$mime;base64,$b64";
</script></body></html>
"@

$tmpDir = Join-Path ([IO.Path]::GetTempPath()) ("webp2png_" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $tmpDir | Out-Null
$tmpHtml = Join-Path $tmpDir "convert.html"
[IO.File]::WriteAllText($tmpHtml, $page, (New-Object System.Text.UTF8Encoding($false)))

try {
    $url = "file:///" + ($tmpHtml -replace "\\", "/")
    $dom = & $browser --headless=new --disable-gpu --no-first-run "--user-data-dir=$tmpDir\profile" --virtual-time-budget=10000 --dump-dom $url 2>$null | Out-String
    $m = [regex]::Match($dom, "OK:data:image/png;base64,([A-Za-z0-9+/=]+)")
    if (-not $m.Success) { throw "Conversion echouee (sortie navigateur : $($dom.Substring(0, [math]::Min(200, $dom.Length))))" }
    [IO.File]::WriteAllBytes($OutFile, [Convert]::FromBase64String($m.Groups[1].Value))
    "{0} -> {1} ({2} KB)" -f (Split-Path $InFile -Leaf), (Split-Path $OutFile -Leaf), [math]::Round((Get-Item $OutFile).Length / 1KB)
} finally {
    Remove-Item -Recurse -Force $tmpDir -ErrorAction SilentlyContinue
}
