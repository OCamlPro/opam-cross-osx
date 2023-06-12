#!/bin/sh

set -e

OPAM_PREFIX="$1"

make install installopt RUNTIMED=false INSTRUMENTED_RUNTIME=false

cp -rf compilerlibs/*.cmxa compilerlibs/*.a "${OPAM_PREFIX}/osx-sysroot/lib/ocaml/compiler-libs"

# Copy META files from ocamlfind
for pkg in bigarray bytes compiler-libs dynlink findlib graphics stdlib str threads unix; do
  if [ -f "${OPAM_PREFIX}/lib/${pkg}/META" ]; then
    mkdir -p "${OPAM_PREFIX}/osx-sysroot/lib/${pkg}"
    cp -r "${OPAM_PREFIX}/lib/${pkg}/META" "${OPAM_PREFIX}/osx-sysroot/lib/${pkg}/META"
  fi
done

mkdir -p "${OPAM_PREFIX}/lib/findlib.conf.d"
cp osx.conf "${OPAM_PREFIX}/lib/findlib.conf.d"
