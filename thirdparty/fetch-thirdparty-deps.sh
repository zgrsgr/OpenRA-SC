#!/bin/sh

####
# This file must stay /bin/sh and POSIX compliant for BSD portability.
# Copy-paste the entire script into http://shellcheck.net to check.
####

# Die on any error for Travis CI to automatically retry:
echo "Fetching thirdparty deps from server."
set -e

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
mv "./deps/linux" "./download"

# Remove junk files:
rm -rf "./deps"

