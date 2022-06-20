
$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url = 'https://github.com/rizki96/workflow_cmd/releases/download/v0.4.8/workflow_cmd-0.4.8.zip'
  checksum = '163D5699D0554A7350DDCE6920E27134148785A35DD5F51FF5E6FF1969EB7EE9'
  checksumType = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
