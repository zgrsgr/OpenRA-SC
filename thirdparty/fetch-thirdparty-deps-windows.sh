#!/bin/bash

# Die on any error for Travis CI to automatically retry:

echo "Fetching thirdparty deps from server."
set -e

if [ $# -ne "1" ]; then
	echo "Usage: $(basename "$0") (32|64)"
	exit 1
fi

if [ "$1" != "x86" ] && [ "$1" != "x64" ]; then
	echo "Usage: $(basename "$0") (32|64)"
	exit 1
fi

cd "${0%/*}" || exit 1

if [ -d "./download" ]; then
	rm -rf download
fi

if [ ! -f "deps.zip" ]; then
	# Download zip:
	echo "Downloading the archive."
	zipFileName="deps-20200503.zip"
	if command -v curl >/dev/null 2>&1; then
		curl -s -L "ftp://139.155.24.179/thirdparty/${zipFileName}" -o "deps.zip"
	else
		wget -cq "ftp://139.155.24.179/thirdparty/${zipFileName}" -O "deps.zip"
	fi
fi

# Extract zip:
echo "Extracting the archive"
unzip -o -qq "deps.zip" 

# Copy files
echo "Copying the archive"
if [ "$1" = "x86" ]; then
	# win32
	cp -r "./deps/win32" "download"
else
	# win64
	cp -r "./deps/win64" "download"
fi

# Remove junk files:
rm -rf "./deps"
