
$ErrorActionPreference = 'Stop';
$packageArgs = @{
  packageName   = 'workflow_cmd'
  url = 'https://github.com/rizki96/workflow_cmd/releases/download/v0.4.0/workflow_cmd-0.4.0.zip'
  checksum = 'D8E71419934EF111E428B4C037B19F05272683B8AF08961EFA0CC727A211A2C0'
}

Install-ChocolateyZipPackage -PackageName $packageArgs.packageName `
 -Url $packageArgs.url `
 -UnzipLocation "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)" `
 -Checksum $packageArgs.checksum `
 -ChecksumType 'SHA256'
