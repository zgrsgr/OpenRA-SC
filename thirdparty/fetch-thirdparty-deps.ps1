mkdir download/windows -Force >$null
echo "Fetching thirdparty deps from server."
$CurrentyDir = Split-Path -Parent $MyInvocation.MyCommand.Definition;

if((Test-Path "$CurrentyDir\download"))
{
	rm -path "$CurrentyDir\download" -Recurse
}

if (!(Test-Path "$CurrentyDir.\deps.zip"))
{
	# Download zip:
	echo "Downloading the archive."
	$zipFileName = "deps-20200503.zip"
	$target = Join-Path $CurrentyDir.ToString() "deps.zip"
	(New-Object System.Net.WebClient).DownloadFile("ftp://139.155.24.179/thirdparty/" + $zipFileName, $target)
}

# Extract zip:
echo "Extracting the archive"
$shellApp = New-Object -ComObject Shell.Application
$files = $shellApp.NameSpace("$CurrentyDir.\deps.zip").Items()
$shellApp.NameSpace("$CurrentyDir").CopyHere($files)

# Copy files
if ([IntPtr]::Size -eq 8)
{
	# win64
	echo "Copying the archive"
	mv "$CurrentyDir\deps\win64" "$CurrentyDir\download"
}
else
{
	# win32
	echo "Copying the archive"
	mv "$CurrentyDir\deps\win32" "$CurrentyDir\download"
} 

# Remove junk files:
rm -path "$CurrentyDir\deps" -Recurse

