param(
    [Parameter(Mandatory = $true)][string]$Key,     # cle dans l'objet IMGS de index.html (ex : suzy)
    [Parameter(Mandatory = $true)][string]$Image,   # PNG detoure (sortie de detourer.ps1)
    [string]$Html = (Join-Path $PSScriptRoot "..\index.html")
)
# Remplace la valeur de IMGS.<Key> dans index.html par l'image en base64.
# La cle doit deja exister dans IMGS (ex : suzy: "__IMG_SUZY__",).
$ErrorActionPreference = "Stop"

$Html = (Resolve-Path $Html).Path
$Image = (Resolve-Path $Image).Path

$b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($Image))
$content = [IO.File]::ReadAllText($Html)

$pattern = '(?m)^(\s*' + [regex]::Escape($Key) + ':\s*)"[^"]*"'
$rx = New-Object System.Text.RegularExpressions.Regex($pattern)
if (-not $rx.IsMatch($content)) {
    throw "Cle '$Key' introuvable dans IMGS ($Html). Ajoute d'abord une ligne '    ${Key}: `"__IMG__`",' dans IMGS."
}
$content = $rx.Replace($content, { param($m) $m.Groups[1].Value + '"data:image/png;base64,' + $b64 + '"' }, 1)

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[IO.File]::WriteAllText($Html, $content, $utf8NoBom)

Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap($Image)
"OK : IMGS.$Key mis a jour ({0}x{1} px -> ratio a utiliser dans CHARACTERS : ar: {1}/{0})" -f $bmp.Width, $bmp.Height
$bmp.Dispose()
"Taille de index.html : {0} KB" -f [math]::Round((Get-Item $Html).Length / 1KB)
