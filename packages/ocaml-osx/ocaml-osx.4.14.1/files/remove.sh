#!/bin/sh -e

OPAM_PREFIX="$1"
HOST="$2"

rm ${OPAM_PREFIX}/.opam-switch/config/ocaml-osx.config

for bin in ocamlc ocamlopt ocamlcp ocamlmklib ocamlmktop ocamldoc ocamldep; do
  rm -f "${OPAM_PREFIX}/bin/${HOST}-${bin}"
done
