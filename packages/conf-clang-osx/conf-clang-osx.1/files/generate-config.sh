#!/bin/sh

PREFIX=$1
$(${PREFIX}osxcross-conf)
INCLUDE=$OSXCROSS_SDK/usr/include
LIB=$OSXCROSS_SDK/usr/lib
HOST=$(${PREFIX}clang -dumpmachine)

echo "prefix: \"${PREFIX}\"" > conf-clang-osx.config
echo "c-include: \"${INCLUDE}\"" >> conf-clang-osx.config
echo "c-lib: \"${LIB}\"" >> conf-clang-osx.config
echo "host: \"${HOST}\"" >> conf-clang-osx.config
