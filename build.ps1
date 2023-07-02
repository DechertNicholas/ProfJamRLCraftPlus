# github build file. Downloads the specified version of RLCraft and makes the necessary changes.

$ErrorActionPreference = "Stop"

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

$clientFolderPrefix = ".\client\overrides\mods"
$serverFolderPrefix = ".\server\mods"

$mods = Get-Content '.\Modpack Configurations\AddedMods.json' | ConvertFrom-Json

Write-Output "---- Downloading Mods ----"
foreach ($common in $mods.common) {
    Write-Output "Processing $($common.name)"
    Invoke-WebRequest -Uri $common.url -OutFile "$clientFolderPrefix\$($common.fileName)"
    Copy-Item "$clientFolderPrefix\$($common.fileName)" "$serverFolderPrefix\$($common.fileName)"
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

Write-Output "Processing Lycanite's Mobs"
$lMobsPath = ".\server\config\lycanitesmobs\mobevents.cfg"
$lMobs = Get-Content $lMobsPath -Raw
$lMobs.Replace("B:`"Mob Events Enabled`"=true", "B:`"Mob Events Enabled`"=false") | Out-File $lMobsPath

Write-Output "---- Processing Scripts ----"
Write-Output "Editing Shiv.zs"
$shiv = Get-Content ".\client\overrides\scripts\Shiv.zs" -Raw
$start = $shiv.IndexOf("recipes.addShaped(`"lolarecipe71`"")
$end = $shiv.IndexOf(";", $start)
$length = $end - $start
$shiv.Remove($start, $length + 1).Insert($start, "# lolarecipe71 (Chiller) moved to Valyrin.zs") `
    | Out-File ".\client\overrides\scripts\Shiv.z"
Copy-Item ".\client\overrides\scripts\Shiv.zs" ".\server\scripts\Shiv.zs" -Force

Write-Output "Copying Valyrin.zs"
Copy-Item '.\Modpack Configurations\scripts\Valyrin.zs' ".\client\overrides\scripts\Valyrin.zs"
Copy-Item '.\Modpack Configurations\scripts\Valyrin.zs' ".\server\scripts\Valyrin.zs"

Write-Output "---- Compressing Archives ----"
$version = "1.3.2"
New-Item -ItemType Directory -Name "artifacts" -ErrorAction "SilentlyContinue" | Out-Null
Compress-Archive -Path ".\client\overrides\*" -DestinationPath ".\artifacts\ProfJam's RLCraft+ $version.zip"
Compress-Archive -Path ".\server\*" -DestinationPath ".\artifacts\ProfJam's RLCraft+ $version-Server.zip"