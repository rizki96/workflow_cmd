
$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url = 'https://github.com/rizki96/workflow_cmd/releases/download/v0.4.6/workflow_cmd-0.4.6.zip'
  checksum = '85DBD9DAC9C56A272BE18FEC1B3CBB51A93E1B7BAF09B60B762F159502A67E02'
  checksumType = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
