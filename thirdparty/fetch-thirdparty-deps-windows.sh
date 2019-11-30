#!/bin/bash

# Die on any error for Travis CI to automatically retry:

set -e

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

mv "./OpenRA_thirdparty_deps/windows" "./download"

rm -rf "./OpenRA_thirdparty_deps"
