#!/bin/bash

# PERSONALIZATON :

# You probably want to change this:

export HOST_CC="i686-linux-gnu-gcc-8" # default: gcc
export HOST_CXX="i686-linux-gnu-g++-8" # default: g++
export CPU_COUNT="4"
export LANGS="c,c++" # default: c,c++ but fortran should also work

export SOURCES_DIR="/home/szilard/Asztal/BB10/bb10-toolchain/BB10_tools"
export BUILD_DIR="/mnt/ramdisk"

# ----------------------------------------

# GLOBAL EXPORTS :

#export HOST_MACHINE=`uname -m`
#export HOST_PLATFORM=`uname -i`
#export HOST_KERNEL=`uname -s | tr '[:upper:]' '[:lower:]'` # should be lowercase, default: linux

export HOST_MACHINE="x86" # this is what BB used
export HOST_PLATFORM="pc"
export HOST_KERNEL="linux"

export OUTPUT_FOLDER="/home/szilard/Asztal/opt/qnx800" # default: /opt/qnx800
export TARGET_FOLDER="$OUTPUT_FOLDER/target" # default: /opt/qnx800/target
export HOST_FOLDER="$OUTPUT_FOLDER/host" # default: /opt/qnx800/host
export TARGET_ABI="arm-unknown-nto-qnx8.0.0eabi" # default: arm-unknown-nto-qnx8.0.0eabi
export HOST_OS="$HOST_MACHINE-$HOST_PLATFORM-$HOST_KERNEL-gnu" # default: i686-pc-linux-gnu
export PREFIX="$HOST_FOLDER/$HOST_KERNEL/$HOST_MACHINE/usr"
export BUGURL="https://github.com/extrowerk/bb10-toolchain/"

# ----------------------------------------

# ENVIRONMENT :

source ~/bbndk/bbndk-env_10_3_1_995.sh

export CFLAGS="$CFLAGS -m32" # this will make a 32 bit executable
export CXXFLAGS="$CXXFLAGS -m32" # if you want a 64 bit toolchain
export LDFLAGS="$LDFLAGS -m32" # then remove them

export PATH="$PREFIX/bin:$PATH"
export LIBDIR="$PREFIX/lib:$LIBDIR"

# ----------------------------------------

# PREPARATION :

rm -rf "$OUTPUT_FOLDER"
mkdir -p "$TARGET_FOLDER/qnx6/usr/"

cp -R ~/bbndk/target_10_3_1_995/qnx6/usr/include/ "$TARGET_FOLDER/qnx6/usr/" && # Let's run it in the background

mkdir -p $SOURCES_DIR
cd $SOURCES_DIR

# ----------------------------------------

# DOWNLOADS :

git clone --depth 1 https://github.com/extrowerk/bb10-binutils.git
git clone --depth 1 https://github.com/extrowerk/bb10-gcc.git
git clone --depth 1 https://github.com/extrowerk/bb10-libmpc.git bb10-gcc/mpc
git clone --depth 1 https://github.com/extrowerk/bb10-libgmp.git bb10-gcc/gmp
git clone --depth 1 https://github.com/extrowerk/bb10-libmpfr.git bb10-gcc/mpfr


ISL=isl-0.23.tar.xz
if [ ! -e "$ISL" ]; then
	wget http://isl.gforge.inria.fr/isl-0.23.tar.xz
	tar -xvf isl-0.23.tar.xz
	mv ./isl-0.23 ./bb10-gcc/isl
fi

# ----------------------------------------

# RECONFIGURE MPFR :

cd bb10-gcc/mpfr
autoreconf -f -i # make sure you have autoconf-archive installed!
cd ../..

# ----------------------------------------

set -e # Exit on first error

# ----------------------------------------

# BINUTILS :

mkdir -p $BUILD_DIR/bb10-binutils-build
cd $BUILD_DIR/bb10-binutils-build

$SOURCES_DIR/bb10-binutils/configure \
	--srcdir=$SOURCES_DIR/bb10-binutils \
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
	CC="$HOST_CXX" \
	LDFLAGS="-Wl,-s " \
	AUTOMAKE=: AUTOCONF=: AUTOHEADER=: AUTORECONF=: ACLOCAL=:

make -j "$CPU_COUNT"
make install
cd ..

# ----------------------------------------

# GCC :

mkdir -p $BUILD_DIR/bb10-gcc-build
cd $BUILD_DIR/bb10-gcc-build

$SOURCES_DIR/bb10-gcc/configure \
	--srcdir=$SOURCES_DIR/bb10-gcc \
	--build="$HOST_OS" \
	--enable-gnu-indirect-function=yes \
	--enable-cxx-flags=-stdlib=libstdc++ \
	--enable-cheaders=c_global \
	--enable-initfini-array \
	--enable-default-pie \
	--with-as="$PREFIX/bin/$TARGET_ABI"-as \
	--with-ld="$PREFIX/bin/$TARGET_ABI"-ld \
	--with-float=softfp \
	--with-arch=armv7-a \
	--with-fpu=vfpv3-d16 \
	--with-mode=thumb \
	--prefix="$PREFIX" \
	--libexecdir="$PREFIX/lib" \
	--with-gxx-include-dir="$TARGET_FOLDER/qnx6/usr/include/c++/8.3.0" \
	--enable-threads=posix \
	--enable-__cxa_atexit \
	--enable-languages="$LANGS" \
	--with-sysroot="$TARGET_FOLDER/qnx6/" \
	--target="$TARGET_ABI" \
	--disable-nls \
	--disable-tls \
	--disable-libssp \
	--disable-libstdcxx-pch \
	--enable-libgomp \
	--enable-shared \
	--with-bugurl="$BUGURL" \
	--enable-default-ssp \
	--with-specs=%{!shared-libgcc:-static-libgcc} \
	CC="$HOST_CC" \
	CC="$HOST_CXX" \
	LDFLAGS='-Wl,-s ' \
	AUTOMAKE=: AUTOCONF=: AUTOHEADER=: AUTORECONF=: ACLOCAL=:

make all -j "$CPU_COUNT"
make install-strip

# CLEANUP

# We need to create a symlink: libstdc++.{a,so} > libc++.{a,so}
# This is strange, do QNX cals it so?

LIBDIR="$PREFIX/$TARGET_ABI/lib"
ln -s $LIBDIR/libstdc++.so $LIBDIR/libc++.so
ln -s $LIBDIR/libstdc++.a $LIBDIR/libc++.a

echo "Have fun!"

