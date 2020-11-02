#!/bin/bash

# PERSONALIZATON

# You probably want to change this:

export HOST_CC="gcc" # default: gcc
export CPU_COUNT="4"
export HOST_KERNEL="linux"
export HOST_PLATFORM=`uname -i`
export HOST_MACHINE=`uname -m`
export OUTPUT_FOLDER="/opt/qnx800" # default: /opt/qnx800
export TARGET_FOLDER="$OUTPUT_FOLDER/target" # default: /opt/qnx800/target
export HOST_FOLDER="$OUTPUT_FOLDER/host" # default: /opt/qnx800/host
export TARGET_ABI="arm-unknown-nto-qnx8.0.0eabi" # default arm-unknown-nto-qnx8.0.0eabi
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

# DOWNLOAD

git clone https://github.com/extrowerk/bb10-binutils.git
git clone https://github.com/extrowerk/bb10-libmpc.git
git clone https://github.com/extrowerk/bb10-libgmp.git
git clone https://github.com/extrowerk/bb10-libmpfr.git
git clone https://github.com/extrowerk/bb10-gcc.git

# ----------------------------------------

# GMP:

mkdir -p bb10-libgmp-build
cd bb10-libgmp-build

../bb10-libgmp/configure \
    --srcdir=../bb10-libgmp \
    --build="$HOST_OS" \
    --with-sysroot="$TARGET_FOLDER/qnx6/" \
    --libdir="$PREFIX/lib" \
    --libexecdir="$PREFIX/lib" \
    --prefix="$PREFIX" \
    --exec-prefix="$PREFIX" \
    --enable-shared \
    CC="$HOST_CC" \
    LDFLAGS="-Wl,-s " \
    AUTOMAKE=: AUTOCONF=: AUTOHEADER=: AUTORECONF=: ACLOCAL=:

make -j "$CPU_COUNT"
make install
cd ..

# ----------------------------------------

# MPC:

mkdir -p bb10-libmpc-build
cd bb10-libmpc-build

../bb10-libmpc/configure \
    --srcdir=../bb10-libmpc \
    --build="$HOST_OS" \
    --with-sysroot="$TARGET_FOLDER/qnx6/" \
    --libdir="$PREFIX/lib" \
    --libexecdir="$PREFIX/lib" \
    --target="$TARGET_ABI" \
    --prefix="$PREFIX" \
    --exec-prefix="$PREFIX" \
    --enable-shared \
    CC="$HOST_CC" \
    LDFLAGS="-Wl,-s " \
    AUTOMAKE=: AUTOCONF=: AUTOHEADER=: AUTORECONF=: ACLOCAL=:

make -j "$CPU_COUNT"
make install
cd ..

# ----------------------------------------

# MPFR:

mkdir -p bb10-libmpfr-build
cd bb10-libmpfr-build

../bb10-libmpfr/configure \
    --srcdir=../bb10-libmpfr \
    --build="$HOST_OS" \
    --with-sysroot="$TARGET_FOLDER/qnx6/" \
    --libdir="$PREFIX/lib" \
    --libexecdir="$PREFIX/lib" \
    --target="$TARGET_ABI" \
    --prefix="$PREFIX" \
    --exec-prefix="$PREFIX" \
    --enable-shared \
    CC="$HOST_CC" \
    LDFLAGS="-Wl,-s " \
    AUTOMAKE=: AUTOCONF=: AUTOHEADER=: AUTORECONF=: ACLOCAL=:

make -j "$CPU_COUNT"
make install
cd ..

# ----------------------------------------

# BINUTILS:

mkdir -p bb10-binutils-build
cd bb10-binutils-build

ac_cv_func_ftello64=no
ac_cv_func_fseeko64=no
ac_cv_func_fopen64=no
CFLAGS='$CFLAGS -Wno-shadow -Wno-format -Wno-sign-compare';
LDFLAGS='-Wl,-s '

../bb10-binutils/configure \
    --srcdir=../bb10-binutils \
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
    --enable-languages=c++ \
    --enable-threads=posix \
    --disable-nls \
    --disable-tls \
    --disable-libssp \
    --disable-libstdcxx-pch \
    --enable-libmudflap \
    --enable-__cxa_atexit \
    --with-gxx-include-dir="$TARGET_FOLDER/qnx6/usr/include/c++/8.3.0" \
    --disable-shared \
    --enable-multilib \
    --with-bugurl="$BUGURL" \
    --enable-gnu-indirect-function \
    --enable-stack-protector \
    --with-float=softfp \
    --with-arch=armv7-a \
    --with-fpu=vfpv3-d16 \
    --with-mode=thumb \
    --disable-initfini-array \
    CC="$HOST_CC" \
    LDFLAGS="-Wl,-s " \
    AUTOMAKE=: AUTOCONF=: AUTOHEADER=: AUTORECONF=: ACLOCAL=:

make -j "$CPU_COUNT"
make install
cd ..

# ----------------------------------------

# GCC:

mkdir -p bb10-gcc-build
cd bb10-gcc-build

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
    --enable-languages=c++ \
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

make -j "$CPU_COUNT"
make install
cd ..

