#!/bin/bash

set -exo pipefail

export LIBS="$(pkg-config --libs-only-l zlib) $LIBS"
export LDFLAGS="$(pkg-config --libs-only-L zlib) -lrt $LDFLAGS"
# The upstream build enables -Werror for every directory (config/eu.am). Newer
# GCC releases warn on code that upstream still compiles cleanly, so keep the
# warnings but never turn them into hard errors (CFLAGS/CXXFLAGS are appended
# after AM_CFLAGS/AM_CXXFLAGS, so -Wno-error wins).
export CFLAGS="$(pkg-config --cflags zlib) -Wno-null-dereference -Wno-error $CFLAGS"
export CXXFLAGS="-Wno-error $CXXFLAGS"
./configure --prefix=$PREFIX --with-zlib --enable-libdebuginfod=dummy --disable-debuginfod || (cat config.log && exit 1)
make -j${CPU_COUNT} srcfiles_no_Werror=1

# Unfortunately some tests fail, so we can't run "make check" here.
# This is probably due to this package being a very sensitive package.
# I believe this happens because it is not ready to be packaged into
# an environment such as conda where it will run in different OSes,
# environments, etc.
#
# For example, when running the tests on my personal machine, using
# the docker image provided by condaforge, 8 tests failed, while in
# CircleCI, 4 tests failed.

make install
