
$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url = 'https://github.com/rizki96/workflow_cmd/releases/download/v0.5.1/workflow_cmd-0.5.1.zip'
  checksum = '771D8D92A6E8DE2E2AA1965BCD9668FA4609CBBBF940FAC503752F2C9801E1F1'
  checksumType = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
