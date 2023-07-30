# github build file. Downloads the specified version of RLCraft and makes the necessary changes.

$ErrorActionPreference = "Stop"

$version = "1.3.4"

# cleanup
Remove-Item .\client* -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item .\server* -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item .\artifacts\* -Recurse -Force -ErrorAction SilentlyContinue

# RLCraft 2.9.3 (client)
$clientURL = "https://mediafilez.forgecdn.net/files/4612/979/RLCraft+1.12.2+-+Release+v2.9.3.zip"
# Server
$serverURL = "https://mediafilez.forgecdn.net/files/4612/990/RLCraft+Server+Pack+1.12.2+-+Release+v2.9.3.zip"

$clientZip = "client.zip"
$serverZip = "server.zip"

$ProgressPreference = "SilentlyContinue"
Write-Output "---- Downloading Zips ----"
Write-Output "Downloading client zip"
Invoke-WebRequest -Uri $clientURL -OutFile $clientZip
Write-Output "Downloading server zip"
Invoke-WebRequest -Uri $serverURL -OutFile $serverZip

Write-Output "Extracting client zip"
Expand-Archive $clientZip -DestinationPath .\client
Write-Output "Extracting server zip"
Expand-Archive $serverZip -DestinationPath .\server

#$clientFolderPrefix = ".\client\overrides\mods"
$serverFolderPrefix = ".\server\mods"

$mods = Get-Content '.\Modpack Configurations\AddedMods.json' | ConvertFrom-Json

Write-Output "---- Downloading Mods ----"
foreach ($common in $mods.common) {
    Write-Output "Processing $($common.name)"
    Invoke-WebRequest -Uri $common.url -OutFile "$serverFolderPrefix\$($common.fileName)"
    #Copy-Item "$clientFolderPrefix\$($common.fileName)" "$serverFolderPrefix\$($common.fileName)"
}

foreach ($server in $mods.server) {
    Write-Output "Processing $($server.name)"
    Invoke-WebRequest -Uri $server.url -OutFile "$serverFolderPrefix\$($server.fileName)"
}

Write-Output "---- Processing configuration changes ----"
Write-Output "Processing Reskillable"
$reskillable = Get-Content ".\client\overrides\config\reskillable.cfg" -Raw
$start = $reskillable.IndexOf("S:`"Skill Locks`" <")
$end = $reskillable.IndexOf(">", $start)
$addins = Get-Content '.\Modpack Configurations\config\reskillable-addons.cfg' -Raw
$reskillable.Insert($end, "$addins`n    ") | Out-File ".\client\overrides\config\reskillable.cfg"
Copy-Item ".\client\overrides\config\reskillable.cfg" ".\server\config\reskillable.cfg"

Write-Output "Processing Tinker's Construct"
Copy-Item '.\Modpack Configurations\config\tconstruct.cfg' ".\client\overrides\config\tconstruct.cfg"
Copy-Item '.\Modpack Configurations\config\tconstruct.cfg' ".\server\config\tconstruct.cfg"

# TODO: Dynamically add this instead of overwriting the whole file
Write-Output "Processing ArmorUnder"
Copy-Item '.\Modpack Configurations\config\wabbity_armorunder.cfg' ".\client\overrides\config\wabbity_armorunder.cfg"
Copy-Item '.\Modpack Configurations\config\wabbity_armorunder.cfg' ".\server\config\wabbity_armorunder.cfg"

Write-Output "Processing Lycanite's Mobs"
$lMobsPath = ".\server\config\lycanitesmobs\mobevents.cfg"
$lMobs = Get-Content $lMobsPath -Raw
$lMobs.Replace("B:`"Mob Events Enabled`"=true", "B:`"Mob Events Enabled`"=false") | Out-File $lMobsPath

$lSpawnPath = ".\server\config\lycanitesmobs\spawning.cfg"
$lSpawn = Get-Content $lSpawnPath -Raw
$lSpawn.Replace(
    "D:`"Mob Limit Search Range`"=32.0", "D:`"Mob Limit Search Range`"=22.0"
    ).Replace(
        "I:`"Mob Type Limit`"=16", "I:`"Mob Type Limit`"=4"
    ).Replace('B:"Ignore WorldGen Spawning"=true', 'B:"Ignore WorldGen Spawning"=false'
    ) | Out-File $lSpawnPath

Write-Output "---- Processing Scripts ----"
Write-Output "Editing Shiv.zs"
$shiv = Get-Content ".\client\overrides\scripts\Shiv.zs" -Raw
$start = $shiv.IndexOf("recipes.addShaped(`"lolarecipe71`"")
$end = $shiv.IndexOf(";", $start)
$length = $end - $start
$shiv.Remove($start, $length + 1).Insert($start, "# lolarecipe71 (Chiller) moved to Valyrin.zs") `
    | Out-File ".\client\overrides\scripts\Shiv.zs" -Encoding ascii
Copy-Item ".\client\overrides\scripts\Shiv.zs" ".\server\scripts\Shiv.zs" -Force

Write-Output "Copying Valyrin.zs"
Copy-Item '.\Modpack Configurations\scripts\Valyrin.zs' ".\client\overrides\scripts\Valyrin.zs"
Copy-Item '.\Modpack Configurations\scripts\Valyrin.zs' ".\server\scripts\Valyrin.zs"

Write-Output "---- Editing manifest and modlist files ----"
$manifest = Get-Content ".\client\manifest.json" | ConvertFrom-Json
$modlist = Get-Content ".\client\modlist.html" -Raw
$end = $modlist.IndexOf("</ul>")

foreach ($common in $mods.common) {
    $manifest.files += [PSCustomObject]@{
        projectID = $common.projectID
        fileID = $common.fileID
        required = $true
    }
    $modlist = $modlist.Insert($end, "<li><a href=`"$($common.home)`">$($common.name) (by $($common.publisher))</a></li>`n")
}
Write-Output "Writing modlist.html"
$modlist | Out-File ".\client\modlist.html" -Force

$manifest.name = "ProfJam's RLCraft+"
$manifest.version = $version
$manifest.author = "Valyrin_"

Write-Output "Writing manifest.json"
$manifest | ConvertTo-Json -Depth 9 | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) } | Out-File ".\client\manifest.json" -Encoding ascii

# build the container-friendly version
Write-Output "Building the server-container version"
New-Item -ItemType Directory -Path ".\server-container"
Copy-Item ".\client\*" ".\server-container\" -Recurse
# just copy all the server configs
Copy-Item ".\server\config\*" ".\server-container\overrides\config\" -Recurse -Force # force overwrite

Write-Output "---- Editing container manifest and modlist files ----"
$cManifest = Get-Content ".\server-container\manifest.json" | ConvertFrom-Json
$cModlist = Get-Content ".\server-container\modlist.html" -Raw
$cEnd = $cModlist.IndexOf("</ul>")

foreach ($server in $mods.server) {
    $cManifest.files += [PSCustomObject]@{
        projectID = $server.projectID
        fileID = $server.fileID
        required = $true
    }
    $cModlist = $cModlist.Insert($cEnd, "<li><a href=`"$($server.home)`">$($server.name) (by $($server.publisher))</a></li>`n")
}
Write-Output "Writing modlist.html"
$cModlist | Out-File ".\server-container\modlist.html" -Force

Write-Output "Writing manifest.json"
$cManifest | ConvertTo-Json -Depth 9 | ForEach-Object { [System.Text.RegularExpressions.Regex]::Unescape($_) } | Out-File ".\server-container\manifest.json" -Encoding ascii

Write-Output "Checking for NanaZip installation"
if ( -not (Test-Path ".\nanazip\nanazip64\NanaZipC.exe") ) {
    $nanazip = @{
        Uri = "https://github.com/M2Team/NanaZip/releases/download/2.0.450/40174MouriNaruto.NanaZip_2.0.450.0_gnj4mf6z9tkrc.msixbundle"
        OutFile = "NanaZip.msixbundle"
    }
    Invoke-WebRequest @nanazip
    Expand-Archive ".\NanaZip.msixbundle" ".\nanazip\"
    Expand-Archive ".\nanazip\NanaZipPackage_2.0.450.0_x64.msix" ".\nanazip\nanazip64\"
}

Write-Output "---- Compressing Archives ----"
New-Item -ItemType Directory -Name "artifacts" -ErrorAction "SilentlyContinue" | Out-Null
Write-Output "Compressing client zip"
Compress-Archive -Path ".\client\*" -DestinationPath ".\artifacts\ProfJam's RLCraft+ $version-Client.zip"
# linux has issues unzipping powershell-compressed zips for some reason, but nanazip works
Write-Output "Compressing server zip"
.\nanazip\nanazip64\NanaZipC.exe a ".\artifacts\ProfJam's RLCraft+ $version-Server.zip" ".\server\*"
Write-Output "Compressing container zip"
.\nanazip\nanazip64\NanaZipC.exe a ".\artifacts\ProfJam's RLCraft+ $version-Container.zip" ".\server-container\*"