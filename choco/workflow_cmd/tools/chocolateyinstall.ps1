
$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url = 'https://github.com/rizki96/workflow_cmd/releases/download/v0.4.5/workflow_cmd-0.4.5.zip'
  checksum = '1A95C565F36AC18EEAE136D765FE3CB24EB6023F66C7FC69286227F62470F0AB'
  checksumType64 = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
