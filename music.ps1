<#
.SYNOPSIS
  PowerShell script for setting up a music environment.

  ! Requires python and pip to be installed.

  TODO: Add usage instructions

.DESCRIPTION
  1. Ensure python and pip are installed and check versions.
  2. Create a virtual environment.
  3. Activate the virtual environment.
  4. Upgrade pip and setuptools
  5. Install pip packages ensuring required dependencies are met for each.

  Tested Python Versions:
    * 3.8.2

  **NOTE** : This script will install the [`PSWriteColor`](https://github.com/EvotecIT/PSWriteColor) module.

.EXAMPLE
  .\music.ps1

.NOTES
  Version:        0.1.0
  Author:         PatEvs (https://github.com/patevs)
  Last Edit:      31/05/2020 - May 31st 2020

.LINK
  Repository:
    * https://github.com/patevs/music
  Script:
    * https://github.com/patevs/music/blob/master/music.ps1
#>

# ------------------------------------ [Initialisations] ------------------------------------ #

# -------------------------------------- [Declarations] ------------------------------------- #

# https://stackoverflow.com/a/2608564

# Current version of the script
Set-Variable version -option Constant -value 0.1.0

# Current Foreground and Background Colors
#   https://stackoverflow.com/a/26583010
# $foreground = (get-host).ui.rawui.ForegroundColor
# $background = (get-host).ui.rawui.BackgroundColor
Set-Variable background -option Constant -value (get-host).ui.rawui.BackgroundColor

# Name of the virtual environment to be created
Set-Variable venvName -option Constant -value "venv"

# --------------------------------------- [Functions] --------------------------------------- #

# Print a Welcome Message
Function PrintWelcome {
  Write-Host ""
  Write-Host " Music Environment Setup Script " -BackgroundColor Magenta -ForegroundColor Black -NoNewline
  Write-Host "`n"
}

# Print a Help Message
Function PrintHelp {
  PrintWelcome
  Write-Host " Usage: "
  Write-Host " `t .\music.ps1"
  Write-Host " `t .\music.ps1 help"
  Write-Host " `t .\music.ps1 version"
  Write-Host ""
  exit
}

# Print the Current Version of the Script
Function PrintVersion {
  PrintWelcome
  Write-Host " Version: " -NoNewLine
  Write-Host "$version" -ForegroundColor Green
  Write-Host ""
  exit
}

# Check if a given PowerShell module is installed
Function ExistsModule ($moduleName) {
  return [bool](Get-Module -ListAvailable -Name $moduleName)
}

# Check if a given command exists
#   https://stackoverflow.com/a/3919904
Function ExistsCommand ($cmdName) {
  return [bool](Get-Command -Name $cmdName -ErrorAction SilentlyContinue)
}

# --------------------------------------- [Execution] --------------------------------------- #

# Validate command line arguments
if ($args.Count -gt 0) {
  # Loop over all arguments
  for ($i = 0; $i -lt $args.Count; $i++) {
    # Check arguments
    switch ( $args[$i] )
    {
      "help" { PrintHelp }
      "version" { PrintVersion }
    }
  }
}

# Print a welcome message
PrintWelcome

# Verify if PSWriteColor module is installed
if (-Not (ExistsModule PSWriteColor)) {
  # TODO: This step requires elevated permissions
  Write-Host "`n PSWriteColor module is not installed. " -NoNewline
  Write-Host "Installing Now... " -ForegroundColor Green -NoNewline
  Install-Module -Name PSWriteColor
  Write-Host " Done " -BackgroundColor Green -ForegroundColor Black
}
Import-Module PSWriteColor
# Uninstall-Module PSWriteColor

# Verify installation requirements are met
Write-Color "Verifying ", "Installation Requirements... `n" -C Green, White -StartSpace 2

# Python
# TODO: Ensure we are using python3
if (ExistsCommand python) {
  $pythonVersion = Invoke-Expression "python --version"
  $pythonVersion = $pythonVersion -replace "Python "
  Write-Color " ", "   Install   ", " ", "   Version   " -B $background, Cyan, $background, Green -C Black, Black, Black, Black -StartSpace 4
  Write-Color "+-------------+-------------+" -StartSpace 4
  Write-Color "|", " python      ", "|", " $pythonVersion       ", "|" -C White, Cyan, White, Green, White -StartSpace 4
  Write-Color "+-------------+-------------+" -StartSpace 4
} else {
  Write-Color "python", " installation could not be found. " -C Cyan, White -StartSpace 2 -NoNewLine
  Write-Color " Exiting " -B Red
  exit
}

# Pip
if (ExistsCommand pip) {
  $pipVersion = Invoke-Expression "pip --version"
  $pipVersion = $pipVersion -replace "pip "
  $pipVersion = $pipVersion.Split(" ")[0]
  Write-Color "|", " pip         ", "|", " $pipVersion      ", "|" -C White, Cyan, White, Green, White -StartSpace 4
  Write-Color "+-------------+-------------+" -StartSpace 4
} else {
  Write-Color "pip", " installation could not be found. " -C Cyan, White -StartSpace 2 -NoNewLine
  Write-Color " Exiting " -B Red
  exit
}

# ffmpeg
if (ExistsCommand ffmpeg) {
  $ffmpegVersion = Invoke-Expression "ffmpeg -version"
  $ffmpegVersion = $ffmpegVersion -replace "ffmpeg version "
  $ffmpegVersion = $ffmpegVersion.Split(" ")[0]
  Write-Color "|", " ffmpeg      ", "|", " $ffmpegVersion       ", "|" -C White, Cyan, White, Green, White -StartSpace 4
  Write-Color "+-------------+-------------+" -StartSpace 4
} else {
  Write-Color "ffmpeg", " installation could not be found. " -C Cyan, White -StartSpace 2 -NoNewLine
  Write-Color " Exiting " -B Red
  exit
}

# Begin Setup
Write-Color " `n All Requirements Satisfied! ", "Beginning Environment Setup... `n" -C White, Green

# Create a virtual environment redirecting output to null
#   https://stackoverflow.com/a/6461021
try {
  Write-Color "Creating", " Virtual Environment...   " -C Green, White -StartSpaces 4 -NoNewLine
  Invoke-Expression "python -m venv $venvName 2>&1 | Out-Null"
  Write-Color " Done " -B Green -C Black
} catch {
  Write-Color "Failed to Create Virtual Environment... " -C Cyan, White -StartSpace 2 -NoNewLine
  Write-Color " Exiting " -B Red
  exit
}

# Activate the virtual environment
Write-Color "Activating", " Virtual Environment... " -C Green, White -StartSpaces 4 -NoNewLine
Invoke-Expression "$venvName/Scripts/activate"
Write-Color " Done " -B Green -C Black

# Upgrade pip and setuptools redirecting output to null
Write-Color "Upgrading ", "pip", " and ", "setuptools", "...   " -C Green, Cyan, White, Cyan, White -StartSpace 4 -NoNewLine
Invoke-Expression "pip install --upgrade pip 2>&1 | Out-Null"
Invoke-Expression "pip install --upgrade setuptools 2>&1 | Out-Null"
Write-Color " Done " -B Green -C Black

# Begin Install
Write-Color " `n Environment Setup Complete! ", "Beginning Install... `n" -C White, Green

# Install spotify-downloader redirecting output to null
Write-Color "Installing", " Spotify Downloader... " -C Green, White -StartSpaces 4 -NoNewLine
# Invoke-Expression "pip install spotdl 2>&1 | Out-Null"
Invoke-Expression "pip install spotdl<2 2>&1 | Out-Null"
Write-Color " Done " -B Green -C Black

Write-Host ""
Write-Host " Usage Instructions " -BackgroundColor Magenta -ForegroundColor Black -NoNewline
Write-Host "`n"
Write-Color "Save Playlist:      spotdl -p <playlist-url>" -StartSpaces 2
Write-Color "Download Playlist:  spotdl --list <playlist-file>" -StartSpaces 2
Write-Color "Download Song:      spotdl -s <song-url>" -StartSpaces 2

Write-Color ""
Write-Color " DONE " -B Green -C Black -NoNewLine
Write-Color "`n"

# ------------------------------------------ [END] ------------------------------------------ #
