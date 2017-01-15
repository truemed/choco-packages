$ErrorActionPreference = 'Stop';
$packageName= 'modsecurity'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/SpiderLabs/ModSecurity/releases/download/v2.9.1/ModSecurityIIS_2.9.1-32b.msi'
$url64      = 'https://github.com/SpiderLabs/ModSecurity/releases/download/v2.9.1/ModSecurityIIS_2.9.1-64b.msi'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url
  url64bit      = $url64

  softwareName  = 'modsecurity*'

  checksum      = 'bd9c75bd8975c89cc7000679fc4bcee62d7594d36070f9b5ea75b283edf6fac7'
  checksumType  = 'sha256'
  checksum64    = '7ef38c203e97ef5708b06718e46f54239eaf04c27031d40efb39a57bcf2a92f1'
  checksumType64= 'sha256'

  silentArgs    = "/quiet /norestart /l*v `"$env:TEMP\chocolatey\$($packageName)\$($packageName).MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
}

# Detect if Windows Server (if so, we can auto-install IIS if needed)
$WindowsVersion = $(Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion' ProductName).ProductName
if ($WindowsVersion -like 'Windows Server*') { 
    
    # Require IIS WebserverRole
    choco install IIS-WebServerRole -s windowsfeatures
}

Install-ChocolateyPackage @packageArgs


# Configure IIS (Unlock ModSecurity sections so that it can actually be configured).
# This is optional, so in a try-catch.
try {
    $assembly = [System.Reflection.Assembly]::LoadFrom("$env:systemroot\system32\inetsrv\Microsoft.Web.Administration.dll")
    $manager = new-object Microsoft.Web.Administration.ServerManager
    # load appHost config
    $config = $manager.GetApplicationHostConfiguration()

    Write-Host "Unlocking system.webServer/ModSecurity"
    $section = $config.GetSection('system.webServer/ModSecurity')
    $section.OverrideMode = 'Allow'
    $manager.CommitChanges()
    Write-Host "Unlocked system.webServer/ModSecurity"
}
catch { } 

#Download OWASP ModSecurity Rules
$rulesetPath =  "$env:ProgramData\ModSecurity"
Install-ChocolateyZipPackage -PackageName 'owasp-crs' -Url 'https://github.com/SpiderLabs/owasp-modsecurity-crs/archive/v3.0.0.zip' -UnzipLocation $rulesetPath
















