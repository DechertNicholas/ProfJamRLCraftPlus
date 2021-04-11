# Set some constants
$REPO = "DechertNicholas/ProfJamRLCraftPlus"
$FILE = "ProfJamsRLCraft+"
$SCRIPT_TEMP = ".\_UpdateScript"
$SCRIPT_DOWNLOAD = "$SCRIPT_TEMP\Download"
$SCRIPT_EXTRACT = "$SCRIPT_TEMP\Extracted"

# make script dir
if (!(Test-Path $SCRIPT_DOWNLOAD)) {
    New-Item -ItemType Directory -Name $SCRIPT_DOWNLOAD -Force
}

# Get and download the latest release into the cache
# https://gist.github.com/MarkTiedemann/c0adc1701f3f5c215fc2c2d5b1d5efd3

$releases = "https://api.github.com/repos/$repo/releases"
$tag = (Invoke-WebRequest $releases -UseBasicParsing | ConvertFrom-Json)[0].tag_name
$versionedName = $FILE + $tag + ".zip"
$download = "https://github.com/$repo/releases/download/$tag/$versionedName"

Invoke-WebRequest $download -OutFile "$SCRIPT_DOWNLOAD\$versionedName"

Expand-Archive -Path "$SCRIPT_DOWNLOAD\$versionedName" -DestinationPath "$SCRIPT_EXTRACT\$($FILE + $tag)"

$modlist = Get-Content "$SCRIPT_EXTRACT\$($FILE + $tag)\AddedMods.json" | ConvertFrom-Json
foreach ($mod in $modlist.mods) {
    Write-Host "Processing $($mod.Name)..."
    Invoke-WebRequest "$($mod.url)" -OutFile ".\mods\$($mod.fileName)"
}
Write-Host "Copying modified configs..."
Copy-Item -Path "$SCRIPT_EXTRACT\$($FILE + $tag)\config" -Destination .\config -Recurse -Force

# Zip the pack
#& 'C:\Program Files\7-Zip\7z.exe' a "$OUT_DIR\$($PACK_NAME + $tag).zip" "$BUILD_DIR\*"