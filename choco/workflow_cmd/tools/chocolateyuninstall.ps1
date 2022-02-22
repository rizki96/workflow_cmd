$ErrorActionPreference = 'Stop';
$packageArgs = @{
  packageName   = 'workflow_cmd'
  zipFileName   = 'workflow_cmd-0.4.5.zip'
}

Uninstall-ChocolateyZipPackage -PackageName $packageArgs.packageName `
  -ZipFileName $packageArgs.zipFileName
