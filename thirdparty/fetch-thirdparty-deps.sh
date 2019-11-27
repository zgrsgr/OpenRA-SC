#!/bin/sh

####
# This file must stay /bin/sh and POSIX compliant for BSD portability.
# Copy-paste the entire script into http://shellcheck.net to check.
####

# Die on any error for Travis CI to automatically retry:
set -e

download_dir="${0%/*}/download"

mkdir -p "${download_dir}"
cd "${download_dir}" || exit 1

if [ ! -f ICSharpCode.SharpZipLib.dll ]; then
	echo "Fetching ICSharpCode.SharpZipLib from Gitee."
	if command -v curl >/dev/null 2>&1; then
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/ICSharpCode.SharpZipLib.dll
	else
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/ICSharpCode.SharpZipLib.dll
	fi
fi

if [ ! -f MaxMind.Db.dll ]; then
	echo "Fetching MaxMind.Db from Gitee."
	if command -v curl >/dev/null 2>&1; then
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/MaxMind.Db.dll
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/MaxMind.Db.xml
	else
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/MaxMind.Db.dll
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/MaxMind.Db.xml
	fi
fi

if [ ! -f nunit.framework.dll ]; then
	echo "Fetching NUnit from Gitee."
	if command -v curl >/dev/null 2>&1; then
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit-agent-x86.exe
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit-agent-x86.exe.config
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit-agent.exe
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit-agent.exe.config
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit.engine.addin.xml
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit.engine.addins
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit.engine.api.dll
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit.engine.api.xml
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit.engine.dll
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit.framework.dll
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit.framework.xml
	else
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit-agent-x86.exe
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit-agent-x86.exe.config
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit-agent.exe
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit-agent.exe.config
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit.engine.addin.xml
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit.engine.addins
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit.engine.api.dll
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit.engine.api.xml
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit.engine.dll
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit.framework.dll
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit.framework.xml
	fi
fi

if [ ! -f nunit3-console.exe ]; then
	echo "Fetching NUnit.Console from Gitee."
	if command -v curl >/dev/null 2>&1; then
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit3-console.exe
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit3-console.exe.config
	else
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit3-console.exe
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/nunit3-console.exe.config
	fi
fi

if [ ! -f Open.Nat.dll ]; then
	echo "Fetching Open.Nat from Gitee."
	if command -v curl >/dev/null 2>&1; then
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/Open.Nat.dll
	else
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/Open.Nat.dll
	fi
fi

if [ ! -f FuzzyLogicLibrary.dll ]; then
	echo "Fetching FuzzyLogicLibrary from Gitee."
	if command -v curl >/dev/null 2>&1; then
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/FuzzyLogicLibrary.dll
	else
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/FuzzyLogicLibrary.dll
	fi
fi

if [ ! -f SDL2-CS.dll ] || [ ! -f SDL2-CS.dll.config ]; then
	echo "Fetching SDL2-CS from Gitee."
	if command -v curl >/dev/null 2>&1; then
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/SDL2-CS.dll
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/SDL2-CS.dll.config
	else
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/SDL2-CS.dll
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/SDL2-CS.dll.config
	fi
fi

if [ ! -f OpenAL-CS.dll ] || [ ! -f OpenAL-CS.dll.config ]; then
	echo "Fetching OpenAL-CS from Gitee."
	if command -v curl >/dev/null 2>&1; then
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/OpenAL-CS.dll
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/OpenAL-CS.dll.config
	else
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/OpenAL-CS.dll
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/OpenAL-CS.dll.config
	fi
fi

if [ ! -f Eluant.dll ]; then
	echo "Fetching Eluant from Gitee."
	if command -v curl >/dev/null 2>&1; then
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/Eluant.dll
	else
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/Eluant.dll
	fi
fi

if [ ! -f rix0rrr.BeaconLib.dll ]; then
	echo "Fetching rix0rrr.BeaconLib from Gitee."
	if command -v curl >/dev/null 2>&1; then
		curl -s -L -O https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/rix0rrr.BeaconLib.dll
	else
		wget -cq https://gitee.com/CastleJing/OpenRA_thirdparty_deps/raw/master/download/rix0rrr.BeaconLib.dll
	fi
fi

chmod +x *.exe

