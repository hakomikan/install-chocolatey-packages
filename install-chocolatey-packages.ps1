<#
.SYNOPSIS
  Install the chocolatey and its packages form PackageList.txt.

.EXAMPLE
  powershell install-chocolatey-packages.ps1
  
.EXAMPLE
  powershell install-chocolatey-packages.ps1 -PackageList PackageList.txt  
#>

param(
  [string]
  $packageList = (Join-Path (Split-Path -Parent -Path $MyInvocation.MyCommand.Definition) "PackageList.txt"),
  
  [string]
  $workingDirectory = (Join-Path (Split-Path -Parent -Path $MyInvocation.MyCommand.Definition) "WorkingDirectory"),
  
  [string]
  $installScriptUrl = 'https://chocolatey.org/install.ps1'
)

function Get-Chocolatey-Path {
    $chocInstallVariableName = "ChocolateyInstall"
    $chocoPath = [Environment]::GetEnvironmentVariable($chocInstallVariableName)
    if ($chocoPath -eq $null -or $chocoPath -eq '') {
      $chocoPath = 'C:\ProgramData\Chocolatey'
    }

    return (Join-Path $chocoPath "bin/choco.exe")
}

# download install script if not installed.
if(-not (Test-Path (Get-Chocolatey-Path)))
{
    Write-Host "download and invoke the install script."
    $installScript = ((New-Object System.Net.WebClient).DownloadString($installScriptUrl))
    Invoke-Expression "$installScript"
}

# install packages from PackageList
$packageNames = (Get-Content -Path $packageList) -join " "

$chocolatery = (Get-Chocolatey-Path)

Invoke-Expression "& $chocolatery install $packageNames"

<#
$downloader = New-Object System.Net.WebClient

$fileName = Split-Path $setupExeUrl -Leaf
$downloadPath = Join-Path $workingDirectory $fileName
$packageDirectory = Join-Path $workingDirectory "Packages"

if(-not (Test-Path -Path $workingDirectory))
{
    New-Item -ItemType directory -Path $workingDirectory
}

if(-not (Test-Path -Path $packageDirectory))
{
    New-Item -ItemType directory -Path $packageDirectory
}

Push-Location $workingDirectory

if (-not (Test-Path $downloadPath))
{
    Write-Host "Download $setupExeUrl to $downloadPath"
    $downloader.DownloadFile($setupExeUrl, $downloadPath)
    Write-Host "Done."
}

$packageNames = (Get-Content -Path $packageList) -join ","

Write-Host "Download and install packages: $packageNames"
& $downloadPath -q -P $packageNames --local-package-dir $packageDirectory | Out-Default
Write-Host "Done."

Pop-Location
#>
