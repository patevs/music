<#
.SYNOPSIS
  PowerShell script for setting up a disposable environment
  for downloading music from Spotify including metadata.

  ! Requires python 3.6+ and pip to be installed.

.DESCRIPTION
  1. Ensure python and pip are installed and check versions.
  2. Create a virtual environment.
  3. Activate the virtual environment.
  4. Upgrade pip and setuptools
  5. Install pip packages ensuring required dependencies are met for each.

  **NOTE** : This script will install the [`PSWriteColor`](https://github.com/EvotecIT/PSWriteColor) module.

.EXAMPLE
  .\music.ps1

.NOTES
  Version:        0.13.0
  Author:         PatEvs (https://github.com/patevs)
  Last Edit:      06/10/2021 - 6th October 2021

.LINK
  Repository:
    * https://github.com/patevs/music
  Script:
    * https://github.com/patevs/music/blob/master/music.ps1
#>

# ------------------------------------ [Initialisations] ------------------------------------ #

# ...

# -------------------------------------- [Declarations] ------------------------------------- #

# https://stackoverflow.com/a/2608564

# Current version of the script
Set-Variable version -option Constant -value 0.13.0

# Current Foreground and Background Colors
#   https://stackoverflow.com/a/26583010
# $foreground = (get-host).ui.rawui.ForegroundColor
# $background = (get-host).ui.rawui.BackgroundColor
Set-Variable background -option Constant -value (get-host).ui.rawui.BackgroundColor

# Name of the virtual environment to be created
Set-Variable venvName -option Constant -value "venv"

# Enable verbose output
# Set-Variable verbose -value false

# --------------------------------------- [Functions] --------------------------------------- #

# Print a Welcome Message
Function PrintWelcome {
  Write-Host "`n"
  Write-Host "    " -NoNewLine
  Write-Host " Music Environment Setup Script " -BackgroundColor Magenta -ForegroundColor Black -NoNewline
  Write-Host "`n`n"
}

# Print a Help Message
Function PrintHelp {
  Write-Host " Usage Instructions: "
  Write-Host " `t .\music.ps1"
  Write-Host " `t .\music.ps1 help"
  Write-Host " `t .\music.ps1 version"
  Write-Host ""
  exit
}

# Print the Current Version of the Script
Function PrintVersion {
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

# Print a welcome message
PrintWelcome

# Validate command line arguments
# ! See:
#   https://stackoverflow.com/q/2157554
#   https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_switch?view=powershell-7
if ($args.Count -gt 0) {
  # Loop over all arguments
  for ($i = 0; $i -lt $args.Count; $i++) {
    # Check arguments
    switch ( $args[$i] )
    {
      "help" { PrintHelp }
      "-help" { PrintHelp }
      "-h" { PrintHelp }
      "version" { PrintVersion }
      "-version" { PrintVersion }
      "-v" { PrintVersion }
    }
  }
}

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
# TODO: Ensure we are using python 3.6+
if (ExistsCommand python) {
  $pythonVersion = Invoke-Expression "python --version"
  $pythonVersion = $pythonVersion -replace "Python "
  Write-Color " ", "  Install  ", " ", "  Version  " -B $background, Cyan, $background, Green -C Black, Black, Black, Black -StartSpace 4
  Write-Color "+-----------+-----------+" -StartSpace 4
  # Write-Color "|", " python      ", "|", " $pythonVersion       ", "|" -C White, Cyan, White, Green, White -StartSpace 4
  Write-Color "|", " python    ", "|", " $($pythonVersion.PadRight(9)) ", "|" -C White, Cyan, White, Green, White -StartSpace 4
  Write-Color "+-----------+-----------+" -StartSpace 4
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
  # Write-Color "|", " pip         ", "|", " $pipVersion        ", "|" -C White, Cyan, White, Green, White -StartSpace 4
  Write-Color "|", " pip       ", "|", " $($pipVersion.PadRight(9)) ", "|" -C White, Cyan, White, Green, White -StartSpace 4
  Write-Color "+-----------+-----------+" -StartSpace 4
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
  $ffmpegVersion = $ffmpegVersion.Split("-")[0] + "-" + $ffmpegVersion.Split("-")[1]
  $ffmpegVersion = $ffmpegVersion.Replace("n","")
  # Write-Color "|", " ffmpeg      ", "|", " $ffmpegVersion       ", "|" -C White, Cyan, White, Green, White -StartSpace 4
  Write-Color "|", " ffmpeg    ", "|", " $($ffmpegVersion.PadRight(9)) ", "|" -C White, Cyan, White, Green, White -StartSpace 4
  Write-Color "+-----------+-----------+" -StartSpace 4
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
  Write-Color " DONE " -B Green -C Black
} catch {
  Write-Color "Failed to Create Virtual Environment... " -C Cyan, White -StartSpace 2 -NoNewLine
  Write-Color " Exiting " -B Red
  exit
}

# Activate the virtual environment
Write-Color "Activating", " Virtual Environment... " -C Green, White -StartSpaces 4 -NoNewLine
Invoke-Expression "$venvName/Scripts/activate"
Write-Color " DONE " -B Green -C Black

# Upgrade pip and setuptools redirecting output to null
Write-Color "Upgrading ", "pip", " and ", "setuptools", "...   " -C Green, Cyan, White, Cyan, White -StartSpace 4 -NoNewLine
Invoke-Expression "pip install --upgrade pip 2>&1 | Out-Null"
Invoke-Expression "pip install --upgrade setuptools 2>&1 | Out-Null"
Write-Color " DONE " -B Green -C Black

# Install wheel
Write-Color "Installing ", "wheel", "...   " -C Green, Cyan, White -StartSpace 4 -NoNewLine
Invoke-Expression "pip install --upgrade wheel 2>&1 | Out-Null"
Write-Color " DONE " -B Green -C Black -StartSpace 12

# Begin Install
Write-Color " `n Environment Setup Complete! ", "Beginning Install... `n" -C White, Green

# Install spotify-downloader redirecting output to null
Write-Color "Installing", " Spotify Downloader... " -C Green, White -StartSpaces 4 -NoNewLine
Invoke-Expression "pip install spotdl 2>&1 | Out-Null"
Write-Color " DONE " -B Green -C Black

# Apply pytube Patches
# See: https://github.com/spotDL/spotify-downloader/issues/1342#issuecomment-886141496
# Write-Color "Applying ", "pytube", " Patches... " -C Green, Cyan, White -StartSpaces 4 -NoNewLine
# Copy-Item "./patches/pytube/__main__.py" -Destination "./venv/Lib/site-packages/pytube/__main__.py" -Force
# Write-Color " DONE " -B Green -C Black -StartSpaces 6

# Create 'downloads' directory
New-Item -Path ".\downloads" -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
# Set-Location -Path ".\downloads"

Write-Host "`n"
Write-Color "  ", " Usage Instructions " -B $background, Magenta -C Black, Black -NoNewline
Write-Host "`n`n"
Invoke-Expression "spotdl --help"

Write-Host "`n"
Write-Color " DONE " -B Green -C Black -NoNewLine
Write-Host "`n"

# ------------------------------------------ [END] ------------------------------------------ #
