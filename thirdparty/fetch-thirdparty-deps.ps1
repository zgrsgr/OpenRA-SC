mkdir download/windows -Force >$null
$CurrentyDir = Split-Path -Parent $MyInvocation.MyCommand.Definition;
$curl = "$CurrentyDir\curl.exe"

if((Test-Path "$CurrentyDir\download"))
{
	rm -path "$CurrentyDir\download" -Recurse
}

if (!(Test-Path "$CurrentyDir.\deps.zip"))
{
	echo "Fetching thirdparty deps from Gitee."
	&$curl -s -L "https://gitee.com/CastleJing/OpenRA_thirdparty_deps/repository/archive/deps.zip" -o "$CurrentyDir\deps.zip"
}

$shellApp = New-Object -ComObject Shell.Application
$files = $shellApp.NameSpace("$CurrentyDir.\deps.zip").Items()
$shellApp.NameSpace("$CurrentyDir").CopyHere($files)

if ([IntPtr]::Size -eq 8)
{
	mv "$CurrentyDir\OpenRA_thirdparty_deps\win64" "$CurrentyDir\download"
}
else
{
	mv "$CurrentyDir\OpenRA_thirdparty_deps\win32" "$CurrentyDir\download"
} 
rm -path "$CurrentyDir\OpenRA_thirdparty_deps" -Recurse
