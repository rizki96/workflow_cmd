
$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url = 'https://github.com/rizki96/workflow_cmd/releases/download/v0.5.3/workflow_cmd-0.5.3.zip'
  checksum = '67616011C010E4BAA378288BC6A529F4D60118D5C27D33283A782FE5CFECB26F'
  checksumType = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
