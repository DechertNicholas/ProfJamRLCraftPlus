# Set some constants
$BUILD_DIR = Resolve-Path .\buildFolder
$OUT_DIR = Resolve-Path .\releaseOut
$CACHE_DIR = Resolve-Path .\downloadCache
$PACK_NAME = "ProfJam's RLCraft +"
$REPO = "DechertNicholas/ProfJamRLCraftPlus"
$FILE = "ProfJamsRLCraftPlus"

# Create DIRs
if (!(Test-Path $BUILD_DIR)) {
    New-Item -ItemType Directory -Name $BUILD_DIR
}
if (!(Test-Path $OUT_DIR)) {
    New-Item -ItemType Directory -Name $OUT_DIR
}
if (!(Test-Path $CACHE_DIR)) {
    New-Item -ItemType Directory -Name $CACHE_DIR
}
Pause
# Get and download the latest release into the cache
# https://gist.github.com/MarkTiedemann/c0adc1701f3f5c215fc2c2d5b1d5efd3
$releases = "https://api.github.com/repos/$repo/releases"
$tag = (Invoke-WebRequest $releases | ConvertFrom-Json)[0].tag_name
$versionedName = $FILE + $tag + ".zip"
$download = "https://github.com/$repo/releases/download/$tag/$versionedName"

# Zip the pack
& 'C:\Program Files\7-Zip\7z.exe' a "$OUT_DIR\$PACK_NAME.zip" "$BUILD_DIR\*"