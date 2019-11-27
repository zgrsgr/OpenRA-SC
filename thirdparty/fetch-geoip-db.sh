#!/bin/sh

# Die on any error for Travis CI to automatically retry:
set -e

download_dir="${0%/*}/download"
mkdir -p "${download_dir}"
cd "${download_dir}" || exit 1

filename="GeoLite2-Country.mmdb.gz"

# Database does not exist or is older than 30 days.
if [ ! -e $filename ] || [ -n "$(find . -name $filename -mtime +30 -print)" ]; then
	rm -f $filename
	echo "Updating GeoIP country database from Gitee."
	if command -v curl >/dev/null 2>&1; then
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/$filename
	else
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/$filename
	fi
fi

