#!/bin/sh

HOST=$1
PREFIX=${HOST}-

eval $(${PREFIX}osxcross-conf)

OSXCROSS_ROOT=${OSXCROSS_TARGET_DIR}
AR=${OSXCROSS_ROOT}/bin/${PREFIX}ar
AS=${OSXCROSS_ROOT}/bin/${PREFIX}as
CC=${OSXCROSS_ROOT}/bin/${PREFIX}clang
CXX=${OSXCROSS_ROOT}/bin/${PREFIX}clang++
LD=${OSXCROSS_ROOT}/bin/${PREFIX}ld
LIBTOOL=${OSXCROSS_ROOT}/bin/${PREFIX}libtool
NM=${OSXCROSS_ROOT}/bin/${PREFIX}nm
OTOOL=${OSXCROSS_ROOT}/bin/${PREFIX}otool
RANLIB=${OSXCROSS_ROOT}/bin/${PREFIX}ranlib
PKG_CONFIG=${OSXCROSS_ROOT}/bin/${PREFIX}pkg-config

MACPORTS_ROOT=${OSXCROSS_ROOT}/macports/pkgs/opt/local
BIN=${MACPORTS_ROOT}/usr/bin
INCLUDE=${MACPORTS_ROOT}/usr/include
LIB=${MACPORTS_ROOT}/usr/lib
SHARE=${MACPORTS_ROOT}/usr/share

echo "root: \"${OSXCROSS_ROOT}\"" > conf-clang-osx.config
echo "host: \"${HOST}\"" >> conf-clang-osx.config
echo "prefix: \"${PREFIX}\"" >> conf-clang-osx.config

echo "ar: \"${AR}\"" >> conf-clang-osx.config
echo "as: \"${AS}\"" >> conf-clang-osx.config
echo "cc: \"${CC}\"" >> conf-clang-osx.config
echo "cxx: \"${CXX}\"" >> conf-clang-osx.config
echo "ld: \"${LD}\"" >> conf-clang-osx.config
echo "libtool: \"${LIBTOOL}\"" >> conf-clang-osx.config
echo "nm: \"${NM}\"" >> conf-clang-osx.config
echo "otool: \"${OTOOL}\"" >> conf-clang-osx.config
echo "ranlib: \"${RANLIB}\"" >> conf-clang-osx.config
echo "pkg-config: \"${PKG_CONFIG}\"" >> conf-clang-osx.config

echo "bin: \"${BIN}\"" >> conf-clang-osx.config
echo "include: \"${INCLUDE}\"" >> conf-clang-osx.config
echo "lib: \"${LIB}\"" >> conf-clang-osx.config
echo "share: \"${SHARE}\"" >> conf-clang-osx.config
