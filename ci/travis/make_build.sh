#!/usr/bin/env bash
# Prepare the build files for Travis to build

set -ev

cmake --version
mkdir build && cd build

WANT_OPTS="-DWANT_TESTS=ON -DWANT_SAMPLE=ON -DWANT_RENDERER_NULL=ON" # common

function cpp2c {
    local comp=$1
    comp=${comp/clang\+\+/clang}
    comp=${comp/g\+\+/gcc}
    echo $comp
}

function prepare_osx {
    echo "cmake .. -GXcode $WANT_OPTS $2"
    cmake .. -GXcode $WANT_OPTS $2
}

function prepare_linux {
    # Travis doesn't pass on the COMPILER version so we'll use env CXX variable
    local comp=$1
    local ccomp=$(cpp2c $comp)
    echo "Requesting C compiler: $ccomp, C++ compiler: $comp"
    echo "CC=$ccomp CXX=$comp cmake .. -G \"Unix Makefiles\" $WANT_OPTS $2"
    CC=$ccomp CXX=$comp cmake .. -G "Unix Makefiles" $WANT_OPTS $2
}

# args: <C++ compiler> "<want opts>"
prepare_$TRAVIS_OS_NAME "$@"