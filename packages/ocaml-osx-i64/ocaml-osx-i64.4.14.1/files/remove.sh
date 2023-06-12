#!/bin/sh -e

OPAM_PREFIX="$1"

for bin in ocaml ocamlc ocamlcp ocamldebug ocamldep ocamldoc ocamllex ocamlmklib ocamlmktop ocamlobjinfo ocamlopt ocamloptp ocamlprof ocamlrun ocamlyacc; do
  rm -f "${OPAM_PREFIX}/osx-sysroot/bin/${bin}"
done

rm -rf "${OPAM_PREFIX}/osx-sysroot/lib/ocaml"
rm -rf "${OPAM_PREFIX}/lib/findlib.conf.d/osx.conf"
