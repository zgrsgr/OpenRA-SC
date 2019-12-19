#!/bin/bash

# Die on any error for Travis CI to automatically retry:

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
	echo "Fetching thirdparty deps from Gitee."
	if command -v curl >/dev/null 2>&1; then
		curl -s -L "https://gitee.com/CastleJing/OpenRA_thirdparty_deps/repository/archive/deps.zip" -o "deps.zip"
	else
		wget -cq "https://gitee.com/CastleJing/OpenRA_thirdparty_deps/repository/archive/deps.zip" -O "deps.zip"
	fi
fi

unzip -o -qq "deps.zip" 

if [ "$1" = "x86" ]; then
	cp -r "./OpenRA_thirdparty_deps/win32" "windows"
else
	cp -r "./OpenRA_thirdparty_deps/win64" "windows"
fi

mv "windows" "download"

rm -rf "./OpenRA_thirdparty_deps"
