$assembly = [System.Reflection.Assembly]::LoadFrom("$env:systemroot\system32\inetsrv\Microsoft.Web.Administration.dll")
$manager = new-object Microsoft.Web.Administration.ServerManager
# load appHost config
$config = $manager.GetApplicationHostConfiguration()

Write-Host "Unlocking system.webServer/ModSecurity"
$section = $config.GetSection('system.webServer/ModSecurity')
$section.OverrideMode = 'Allow'
$manager.CommitChanges()
Write-Host "Unlocked system.webServer/ModSecurity"