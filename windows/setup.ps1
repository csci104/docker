
# verify Docker is installed on Windows
$docker_installed = ($null -ne (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -eq 'Docker Desktop' }))

if (-Not $docker_installed) {
  Write-Output Docker is not installed or available on path!
  exit 1
}

# install container-helper
.\windows\install-ch.ps1
