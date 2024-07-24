#!/bin/sh -e

OPAM_PREFIX="$1"
HOST="$2"

cat > "ocaml-osx.config" <<EOF
opam-version: "2.0"
variables {
  sysroot: "${OPAM_PREFIX}/osx-sysroot"
}
EOF

for bin in ocamlc ocamlopt ocamlmklib; do
  ln -s "${OPAM_PREFIX}/osx-sysroot/bin/${bin}" "${OPAM_PREFIX}/bin/${HOST}-${bin}"
done

for bin in ocamlmktop ocamldoc ocamldep; do
  ln -s "${OPAM_PREFIX}/bin/${bin}" "${OPAM_PREFIX}/bin/${HOST}-${bin}"
done
