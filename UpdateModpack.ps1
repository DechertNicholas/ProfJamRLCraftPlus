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
if (!(Test-Path $SCRIPT_EXTRACT)) {
    New-Item -ItemType Directory -Name $SCRIPT_EXTRACT -Force
}
# no reason this should ever not exist but uhhhh.... just in case
if (!(Test-Path ".\mods")) {
    New-Item -ItemType Directory -Name ".\mods" -Force
}

# Get and download the latest release into the cache
# https://gist.github.com/MarkTiedemann/c0adc1701f3f5c215fc2c2d5b1d5efd3

$releases = "https://api.github.com/repos/$repo/releases"
$tag = (Invoke-WebRequest $releases -UseBasicParsing | ConvertFrom-Json)[0].tag_name
$versionedName = $FILE + $tag + ".zip"
$download = "https://github.com/$repo/releases/download/$tag/$versionedName"

Invoke-WebRequest $download -OutFile "$SCRIPT_DOWNLOAD\$versionedName"

Expand-Archive -Path "$SCRIPT_DOWNLOAD\$versionedName" -DestinationPath "$SCRIPT_EXTRACT\$($FILE + $tag)"

# download all the mods
$modlist = Get-Content "$SCRIPT_EXTRACT\$($FILE + $tag)\AddedMods.json" | ConvertFrom-Json
foreach ($mod in $modlist.mods) {
    Write-Host "Processing $($mod.Name)..."
    Invoke-WebRequest "$($mod.url)" -OutFile ".\mods\$($mod.fileName)"
}

# copy edited config files and overwrite old ones
Write-Host "Copying modified configs..."
Copy-Item -Path "$SCRIPT_EXTRACT\$($FILE + $tag)\config" -Destination .\ -Recurse -Force

Write-Host "Completed!"
Write-Host "Report any errors to Valyrin on discord, or post an issue in the Github"
Write-Host "Press 'enter' to exit this updater. You should be good to join the server."
pause