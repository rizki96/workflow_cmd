
$ErrorActionPreference = 'Stop';
$packageArgs = @{
  packageName   = 'workflow_cmd'
  url = 'https://github.com/rizki96/workflow_cmd/releases/download/v0.4.5/workflow_cmd-0.4.5.zip'
  checksum = '1A95C565F36AC18EEAE136D765FE3CB24EB6023F66C7FC69286227F62470F0AB'
}

Install-ChocolateyZipPackage -PackageName $packageArgs.packageName `
 -Url $packageArgs.url `
 -UnzipLocation "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)" `
 -Checksum $packageArgs.checksum `
 -ChecksumType 'SHA256'
