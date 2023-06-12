#!/bin/sh

set -e

OPAM_PREFIX="$1"
PREFIX="$2"
HOST="$3"

OPTS=""

if [ `opam var conf-flambda-osx:installed` = "true" ]; then
  OPTS="--enable-flambda"
fi

CC="${PREFIX}clang" ./configure --host=$HOST --prefix="${OPAM_PREFIX}/osx-sysroot" --enable-systhreads ${OPTS}

make -C runtime sak SAK_CC=cc SAK_CFLAGS= SAK_LINK='cc -o $(1) $(2)'

make ocamlopt ocamlc OCAMLRUN=ocamlrun NEW_OCAMLRUN=ocamlrun CAMLC="`which ocamlc`"
make -C tools ocamlmklib OCAMLRUN=ocamlrun NEW_OCAMLRUN=ocamlrun CAMLC="`which ocamlc`"
make boot/ocamlruns
make  -C runtime all
make -C stdlib OCAMLRUN=ocamlrun COMPILER="${PWD}/boot/ocamlc"
make -C yacc OCAMLRUN=ocamlrun NEW_OCAMLRUN=ocamlrun
make -C lex OCAMLRUN=ocamlrun NEW_OCAMLRUN=ocamlrun OCAMLYACC=ocamlyacc CAMLC="`which ocamlc`"
make coldstart OCAMLRUN=ocamlrun NEW_OCAMLRUN=ocamlrun
make -C runtime all libasmrun.a libasmrun_pic.a

make library otherlibs opt ocamlnat ocaml ocamldoc ocamldebugger \
  OCAMLRUN=ocamlrun NEW_OCAMLRUN=ocamlrun \
  OPTCOMPILER="${PWD}/ocamlopt" \
  MKLIB="ocamlrun \"${PWD}/tools/ocamlmklib\"" \
  OCAMLYACC=ocamlyacc
