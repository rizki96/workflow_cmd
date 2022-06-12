
$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url = 'https://github.com/rizki96/workflow_cmd/releases/download/v0.4.6/workflow_cmd-0.4.6.zip'
  checksum = '18F93ABB842E7B58BB0199BDE28EB95B77D48E3275B264BEF010EFDD0CC7884E'
  checksumType = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
