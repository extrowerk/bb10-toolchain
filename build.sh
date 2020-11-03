#!/bin/bash
set -e # Exit on first error

# PERSONALIZATON :

# You probably want to change this:

export HOST_CC="gcc" # default: gcc
export CPU_COUNT="1"
export LANGS="c,c++" # default: c,c++ but fortran and go should also work

# ----------------------------------------

# GLOBAL EXPORTS :

export HOST_KERNEL=`uname -s | tr '[:upper:]' '[:lower:]'` # should be lowercase, default: linux
export HOST_PLATFORM=`uname -i`
export HOST_MACHINE=`uname -m`
export OUTPUT_FOLDER="/opt/qnx800" # default: /opt/qnx800
export TARGET_FOLDER="$OUTPUT_FOLDER/target" # default: /opt/qnx800/target
export HOST_FOLDER="$OUTPUT_FOLDER/host" # default: /opt/qnx800/host
export TARGET_ABI="arm-unknown-nto-qnx8.0.0eabi" # default: arm-unknown-nto-qnx8.0.0eabi
export HOST_OS="$HOST_MACHINE-$HOST_PLATFORM-$HOST_KERNEL-gnu" # default: i686-pc-linux-gnu
export PREFIX="$HOST_FOLDER/$HOST_KERNEL/$HOST_MACHINE/usr"
export BUGURL="https://github.com/extrowerk/bb10-toolchain/"

# ----------------------------------------

# ENVIRONMENT :

source ~/bbndk/bbndk-env_10_3_1_995.sh
export PATH="$PREFIX/bin:$PATH"
export LIBDIR="$PREFIX/lib:$LIBDIR"

# ----------------------------------------

# PREPARATION :

rm -rf "$OUTPUT_FOLDER"
mkdir -p "$TARGET_FOLDER/qnx6/usr/"

cp -R ~/bbndk/target_10_3_1_995/qnx6/usr/include/ "$TARGET_FOLDER/qnx6/usr/"

mkdir -p BB10_tools
cd BB10_tools

# ----------------------------------------

# DOWNLOADS :

wget https://ftp.fau.de/gnu/binutils/binutils-2.35.tar.xz # this is just the vanilla binutils
tar -xvf binutils-2.35.tar.xz
mv binutils-2.35 bb10-binutils

# git clone --branch 0.1 --depth 1 https://github.com/extrowerk/bb10-binutils.git
git clone --branch 0.2 --depth 1 https://github.com/extrowerk/bb10-gcc.git
git clone --branch 0.1 --depth 1 https://github.com/extrowerk/bb10-libmpc.git bb10-gcc/mpc
git clone --branch 0.1 --depth 1 https://github.com/extrowerk/bb10-libgmp.git bb10-gcc/gmp
git clone --branch 0.1 --depth 1 https://github.com/extrowerk/bb10-libmpfr.git bb10-gcc/mpfr

# ----------------------------------------

# RECONFIGURE MPFR :

cd bb10-gcc/mpfr
autoreconf -f -i # make sure you have autoconf-archive installed!
cd ../..

# ----------------------------------------

# BINUTILS :

mkdir -p bb10-binutils-build
cd bb10-binutils-build

../bb10-binutils/configure \
    --srcdir=../bb10-binutils \
    --build="$HOST_OS" \
    --with-sysroot="$TARGET_FOLDER/qnx6/" \
    --disable-werror \
    --libdir="$PREFIX/lib" \
    --libexecdir="$PREFIX/lib" \
    --target="$TARGET_ABI" \
    --prefix="$PREFIX" \
    --exec-prefix="$PREFIX" \
    --with-local-prefix="$PREFIX" \
    CC="$HOST_CC" \
    LDFLAGS="-Wl,-s " \
    AUTOMAKE=: AUTOCONF=: AUTOHEADER=: AUTORECONF=: ACLOCAL=:

make -j "$CPU_COUNT"
make install
cd ..

# ----------------------------------------

# GCC :

mkdir -p bb10-gcc-build
cd bb10-gcc-build

export CFLAGS="" # maybe unneeded
export CFLAGS_FOR_BUILD="" # maybe unneeded
export CFLAGS_FOR_TARGET="-g" # TODO: check why as bails out without this.
export CXXFLAGS="" # maybe unneeded
export CXXFLAGS_FOR_BUILD="" # maybe unneeded
export CXXFLAGS_FOR_TARGET="-g -I/home/szilard/bbndk/target_10_3_1_995/qnx6/usr/include/cpp/c" # TODO: check why as bails out without this.


../bb10-gcc/configure \
    --srcdir=../bb10-gcc \
    --build="$HOST_OS" \
    --enable-cheaders=c \
    --with-as="$TARGET_ABI"-as \
    --with-ld="$TARGET_ABI"-ld \
    --with-sysroot="$TARGET_FOLDER/qnx6/" \
    --disable-werror \
    --libdir="$PREFIX/lib" \
    --libexecdir="$PREFIX/lib" \
    --target="$TARGET_ABI" \
    --prefix="$PREFIX" \
    --exec-prefix="$PREFIX" \
    --with-local-prefix="$PREFIX" \
    --enable-languages="$LANGS" \
    --enable-threads=posix \
    --disable-nls \
    --disable-tls \
    --disable-libssp \
    --disable-libstdcxx-pch \
    --enable-libmudflap \
    --enable-__cxa_atexit \
    --with-gxx-include-dir="$TARGET_FOLDER/qnx6/usr/include/c++/8.3.0" \
    --enable-shared \
    --enable-multilib \
    --with-bugurl="http://www.qnx.com" \
    --enable-gnu-indirect-function \
    --enable-stack-protector \
    --with-float=softfp \
    --with-arch=armv7-a \
    --with-fpu=vfpv3-d16 \
    --with-mode=thumb \
    CC="$HOST_CC" \
    LDFLAGS="-Wl,-s " \
    AUTOMAKE=: AUTOCONF=: AUTOHEADER=: AUTORECONF=: ACLOCAL=:
 
make all-gcc -j "$CPU_COUNT"
make all-target-libgcc -j "$CPU_COUNT"
make all -j "$CPU_COUNT"
#make install-gcc
#make install-target-libgcc
make install
