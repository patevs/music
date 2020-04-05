# ------------------- #
# scripts/install.ps1 #
# ------------------- #

# Requires Python and Pip to be installed and available

# --------------------------------------------------------------------------

# Helper Functions

# Check if a given command exists
# https://stackoverflow.com/questions/3919798/how-to-check-if-a-cmdlet-exists-in-powershell-at-runtime-via-script
function CheckCommand($cmdname) {
    # return [bool](Get-Command -Name $cmdname -ea 0)
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# Creates a virtual environment
function CreateVirtualEnv {
    # TODO: Ensure venv is installed and available
    Write-Host "`n`n Creating Virtual Environment...   " -NoNewline
    $command = "python -m venv beets-env"
    # $result = 
    Invoke-Expression $command
    # if(-not ($result)) {
    #     Write-Host "Failed to Create Virtual Environment. Exiting..." -ForegroundColor Red
    #     exit
    # }
    Write-Host "Done!" -ForegroundColor Green
}

# Activates the virtual environment
function ActivateVirtualEnv {
    Write-Host "` Activating Virtual Environment... " -NoNewline
    $command = "beets-env\scripts\activate"
    Invoke-Expression $command
    Write-Host "Done!" -ForegroundColor Green
}

# Upgrade pip and setuptools
function UpgradePipSetuptools {
    Write-Host "`n Upgrading Pip and Setuptools... " # -NoNewline
    $command = "pip install --upgrade pip"
    Invoke-Expression $command
    $command = "pip install --upgrade setuptools"
    Invoke-Expression $command
    # Write-Host "`n Done! " -ForegroundColor Green
}

# --------------------------------------------------------------------------

Write-Host "`n Beets Install and Setup `n" -ForegroundColor Green
Write-Host " Detecting Python Installation... " -NoNewLine

# Check Python is installed and available
if (CheckCommand python){
    # https://stackoverflow.com/questions/6338015/how-do-you-execute-an-arbitrary-native-command-from-a-string
    $command = 'python -V'
    $pyversion = Invoke-Expression $command # Can use iex instead of Invoke-Expression
    Write-Host $pyversion -ForegroundColor Green -NoNewLine
} else {
    Write-Host "`n`n Python Installation Could Not Be Found! Exiting..." -ForegroundColor Red
    exit
}

Write-Host "`n Detecting Pip Installation...    " -NoNewLine

# Check Pip is installed and available
if (CheckCommand pip){
    $command = 'pip -V'
    $pipversion = Invoke-Expression $command
    Write-Host $pipversion -ForegroundColor Green -NoNewLine
} else {
    Write-Host "`n`n Pip Installation Could Not Be Found! Exiting..." -ForegroundColor Red
    exit
}

# --------------------------------------------------------------------------

# Move into parent directory
$command = "cd ../"
Invoke-Expression $command

if(-not (Test-Path beets-env)) {
    CreateVirtualEnv
}

ActivateVirtualEnv
UpgradePipSetuptools

# Install Beets

Write-Host "`n Installing Beets... `n" -ForegroundColor Green

$command = "pip install beets"
Invoke-Expression $command

# Write-Host "`n Done! " -ForegroundColor Green

# Install Plugin Dependencies

Write-Host "`n Installing Plugin Dependencies... `n" -ForegroundColor Green

$command = "pip install discogs-client pylast"
Invoke-Expression $command

# Write-Host "`n Done! " -ForegroundColor Green

# List pip installations

# Write-Host "`n Listing Pip Installations... `n" -ForegroundColor Green

# $command = "pip list"
# Invoke-Expression $command

# Write-Host "`n`n Done! " -ForegroundColor Green

# Ensure Beets is installed

Write-Host "`n Detecting Beets Installation...`n" # -NoNewLine

$command = 'beet --version'
$beetsversion = Invoke-Expression $command
Write-Host $beetsversion # -ForegroundColor Green -NoNewLine

Write-Host "`n Done! `n" -ForegroundColor Green

# TODO: Copy beets config or set programatically

# EOF #
