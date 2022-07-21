
$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  url = 'https://github.com/rizki96/workflow_cmd/releases/download/v0.5.1/workflow_cmd-0.5.1.zip'
  checksum = '72E50BB77E97A7077BF637097A5F09605D1B83B41BE08E3B8086ECBABD9D671A'
  checksumType = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
