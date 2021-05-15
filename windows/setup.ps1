Function Test-CommandExists ($command) {
 $oldPreference = $ErrorActionPreference
 $ErrorActionPreference = 'stop'
 try {if(Get-Command $command){ return $true }}
 catch { return $false }
 finally {$ErrorActionPreference=$oldPreference}
}

Write-Output "Looking for docker..."
if (-Not (Test-CommandExists -command docker)) {
  Write-Output Docker is not installed or available on path!
  Write-Output Please make sure you have Docker installed before running this script
  exit 1
}

Write-Output "Looking for ch..."
if (-Not (Test-CommandExists -command ch)) {
  Write-Output "Installing ch..."
  .\windows\install-ch.ps1
}

# Get mount point
Write-Output "Preparing csci104 environment..."
$work = Read-Host "Select a directory to mount "

while (-Not (Test-Path -Path $work)) {
  $work = Read-Host "Select a directory to mount "
}

$work = Resolve-Path -Path $work
$conf_path = Join-Path -Path ([Environment]::GetEnvironmentVariable("USERPROFILE")) -ChildPath ".ch.yaml"
Write-Output "Mount point set, this can be changed later by editing $conf_path"

# Create csci104 environment with ch CLI
Write-Output "Creating csci104 environment..."
ch create csci104 --image usccsci104/docker:20.04 --shell /bin/bash --volume ("{0}:/work" -f $work) --security-opt seccomp:unconfined --cap-add SYS_PTRACE --privileged --replace
