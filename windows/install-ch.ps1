$program = "ch"
$repository = "camerondurham/ch"
$zip_filename = "ch-windows-amd64.zip"

function Get-LatestReleaseVersion($repository) {
  # call with Get-LatestReleaseVersion("camerondurham/ch")
  $release_endpoint = "https://api.github.com/repos/$repository/releases/latest"
  $resp = Invoke-WebRequest -Uri $release_endpoint -UseBasicParsing
  $content = ConvertFrom-Json $resp.content
  return $content.tag_name
}

function Get-ReleasePackage($Url, $DownloadPath, $ExtractPath) {
  Invoke-WebRequest $Url -OutFile $DownloadPath
  Write-Output "Unpacking file"
  Expand-Archive -LiteralPath $DownloadPath -DestinationPath $ExtractPath -Force
}

function Get-ReleaseUrl($Repository, $Version, $Filename) {
  # repository: username/reponame format
  #   example: camerondurham/ch
  #    version: version tag to download
  #   example: v0.0.6-beta
  # zip_filename: asset to download
  #      example: ch-windows-amd64.zip
  "https://github.com/{0}/releases/download/{1}/{2}" -f $Repository.Trim(" "), $Version.Trim(" "), $Filename.Trim(" ")
}

function Add-ToPath($directory) {
  if (Test-Path $directory) {
    # add program binary location to path
    $path = [Environment]::GetEnvironmentVariable('Path')
    $newpath = "$path" + ";$directory"

    # set path for future sessions
    [Environment]::SetEnvironmentVariable('Path', $newpath, [EnvironmentVariableTarget]::User)

    # set path for current session
    $env:Path = $newpath
  }
  else {
    Write-Output "Invalid path [$directory] , ignoring..."
  }
}

$latest_version = Get-LatestReleaseVersion($repository)

$download_url = Get-ReleaseUrl -Repository $repository -Version $latest_version -Filename $zip_filename

$home_directory = [Environment]::GetFolderPath("USERPROFILE")

Write-Output "Downloading $program version: $latest_version to $home_directory"

$download_path = Join-Path -Path $home_directory -ChildPath $zip_filename
$unpack_path = $home_directory

Get-ReleasePackage -Url $download_url -DownloadPath $download_path -ExtractPath $unpack_path

# remove zip file
Remove-Item (Join-Path -Path $unpack_path -ChildPath $zip_filename)

$unpacked_folder = $zip_filename.TrimEnd(".zip")
$binary_location = Join-Path -Path $unpack_path -ChildPath $unpacked_folder

Add-ToPath $binary_location

Write-Output "Done! Try using ch with: ch --help"
