opam-cross-osx
==============

This repository contains an up-to-date OSX toolchain featuring OCaml 4.14.1, as well as some commonly used packages.

The supported build system is 64-bit Intel Linux. The supported target systems are 64-bit Intel and ARM OSX.

Prerequisites
-------------

A C cross-compiler targeting the appropriate OSX platform must be installed. See [https://github.com/tpoechtrager/osxcross] for instructions on how to create such toolchain.

Installation
------------

Add this repository to OPAM:

    opam repository add osx https://github.com/OCamlPro/opam-cross-osx.git

The version of the regular compiler installed in your current `opam` switch must match the version of the cross-compiler:

    opam switch 4.14.1
    eval `opam config env`

If desired, request the compiler to be built with [flambda][] optimizers:

    opam install conf-flambda-osx

[flambda]: https://caml.inria.fr/pub/docs/manual-ocaml/flambda.html

Install the compiler:

    opam install ocaml-osx

The compiler version is selected automatically based on the current OPAM switch;
either ocaml-osx-i64 or ocaml-osx-a64 can be installed in any single one.

Alternatively, specify the path to the C toolchain explicitly:

    TOOLPREFI64=/usr/local/osxcross/bin/x86_64-apple-darwin20.4- opam install ocaml-osx
    TOOLPREFA64=/usr/local/osxcross/bin/arm64-apple-darwin20.4- opam install ocaml-osx

The options have the following meaning:

  * `TOOLPREFI64` and `TOOLPREFA64` specify the compiler path prefix. The tools named `${TOOLPREF*}clang`, `${TOOLPREF*}as`, `${TOOLPREF*}ar`, `${TOOLPREF*}ranlib` and `${TOOLPREF*}ld` must be possible to locate via `PATH`.

The `TOOLPREF*` options are recorded inside the `conf-clang-osx*` packages, so make sure to reinstall those if you wish to switch to a different toolchain. Otherwise, it is not necessary to supply them while upgrading the `ocaml-osx*` packages.

Build some code:

    echo 'let () = print_endline "Hello, world!"' >helloworld.ml
    ocamlfind -toolchain osx ocamlc helloworld.ml -o helloworld.byte
    ocamlfind -toolchain osx ocamlopt helloworld.ml -o helloworld.native

Install some packages:

    opam install re-osx

Write some code using them:

    let () =
      let regexp = Re_pcre.regexp {|\b([a-z]+)\b|} in
      let result = Re.exec regexp "Hello, world!" in
      Format.printf "match: %s\n" (Re.get result 1)

Build it:

    ocamlfind -toolchain osx ocamlopt -package re.pcre -linkpkg test_pcre.ml -o test_pcre

Make an object file out of it and link it with your native project (you'll need to call `caml_startup(argv)` to run OCaml code; see [this article](http://www.mega-nerd.com/erikd/Blog/CodeHacking/Ocaml/calling_ocaml.html)):

    ocamlfind -toolchain osx ocamlopt -package re.pcre -linkpkg -output-complete-obj test_pcre.ml -o test_pcre.o

With opam-osx-cross, cross-compilation is easy!

Porting packages
----------------

OCaml packages often have components that execute at compile-time (camlp4 or ppx syntax extensions, cstubs, OASIS, ...). Thus, it is not possible to just blanketly cross-compile every package in the OPAM repository; sometimes you would even need a cross-compiled and a non-cross-compiled package at once. The package definitions also often need package-specific modification in order to work.

As a result, if you want a package to be cross-compiled, you have to copy the definition from [opam-repository](https://github.com/ocaml/opam-repository), rename the package to add `-osx` suffix while updating any dependencies it could have, and update the build script. Don't forget to add `ocaml-osx` as a dependency!

Findlib 1.5.4 adds a feature that makes porting packages much simpler; namely, an `OCAMLFIND_TOOLCHAIN` environment variable that is equivalent to the `-toolchain` command-line flag. Now it is not necessary to patch the build systems of the packages to select the Osx toolchain; it is often enough to add `["env" "OCAMLFIND_TOOLCHAIN=osx" make ...]` to the build command in the `opam` file.

For projects using OASIS, the following steps will work:

    build: [
      ["env" "OCAMLFIND_TOOLCHAIN=osx"
       "ocaml" "setup.ml" "-configure" "--prefix" "%{prefix}%/osx-sysroot"]
      ["env" "OCAMLFIND_TOOLCHAIN=osx"
       "ocaml" "setup.ml" "-build"]
    ]
    install: [
      ["env" "OCAMLFIND_TOOLCHAIN=osx"
       "ocaml" "setup.ml" "-install"]
    ]
    remove: [["ocamlfind" "-toolchain" "osx" "remove" "pkg"]]
    depends: ["ocaml-osx" ...]

The output of the `configure` script will be entirely wrong, referring to the host configuration rather than target configuration. Thankfully, it is not actually used in the build process itself, so it doesn't matter.

For projects installing the files via OPAM's `.install` files (e.g. [topkg](https://github.com/dbuenzli/topkg)), the following steps will work:

    build: [["ocaml" "pkg/pkg.ml" "build" "--toolchain" "osx" ]]
    install: [["opam-installer" "--prefix=%{prefix}%/osx-sysroot" "pkg.install"]]
    remove: [["ocamlfind" "-toolchain" "osx" "remove" "pkg"]]
    depends: ["ocaml-osx" ...]

Internals
---------

The aim of this repository is to build a cross-compiler while altering the original codebase in the minimal possible way. (Indeed, only about 50 lines are changed.) There are no attempts to alter the `configure` script; rather, the configuration is provided directly. The resulting cross-compiler has several interesting properties:

  * All paths to the OSX toolchain are embedded inside `ocamlc` and `ocamlopt`; thus, no knowledge of the OSX toolchain is required even for packages that have components in C, provided they use the OCaml driver to compile the C code. (This is usually the case.)
  * The build system makes several assumptions that are not strictly valid while cross-compiling, mainly the fact that the bytecode the cross-compiler has just built can be ran by the `ocamlrun` on the build system. Thus, the requirement for the matching versions.
  * The `.opt` versions of the compiler are built using itself, which doesn't work while cross-compiling, so all provided tools are bytecode-based.

License
-------

All files contained in this repository are licensed under the [CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/) license.
