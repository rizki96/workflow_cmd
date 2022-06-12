
$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url = 'https://github.com/rizki96/workflow_cmd/releases/download/v0.4.6/workflow_cmd-0.4.6.zip'
  checksum = '6DF80709015467080B75CCFC9F0F78D33CA28BDD51A84191D6A633C4F80FC9BF'
  checksumType = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
