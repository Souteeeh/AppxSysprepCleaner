<#
.SYNOPSIS
Automatically detects and removes AppX packages that prevent Sysprep from completing.

.DESCRIPTION
This script parses Sysprep's setupact.log to identify AppX packages that were installed
for a user but not provisioned system-wide. It then removes them for all users and from the system image.
#>

# Path to Sysprep's setupact.log
$logPath = "C:\Windows\System32\Sysprep\Panther\setupact.log"

# Pattern to detect problematic AppX packages
$pattern = "SYSPRP Package (.*?) was installed for a user"

# Extract and shorten AppX package names
$matches = Select-String -Path $logPath -Pattern $pattern | ForEach-Object {
    if ($_ -match $pattern) {
        $fullName = $matches[1]
        $shortName = $fullName.Split('_')[0]
        $shortName
    }
}

# Remove duplicates
$badApps = $matches | Sort-Object -Unique

# Display detected AppX packages
Write-Host ""
Write-Host "Detected problematic AppX packages:"
foreach ($app in $badApps) {
    Write-Host " - $app"
}

# Remove AppX packages for all users and from the system
foreach ($app in $badApps) {
    Write-Host ""
    Write-Host "Removing: $app"
    Get-AppxPackage -AllUsers -Name $app | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
    Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -eq $app} | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "Cleanup completed. You can now re-run Sysprep."
