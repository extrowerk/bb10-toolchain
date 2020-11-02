#!/bin/bash

# PERSONALIZATON

# You probably want to change this:

HOST_CC="gcc"
CPU_COUNT="4"
TARGET_FOLDER="/opt/qnx800/target"
HOST_FOLDER="/opt/qnx800/host"
HOST_OS="i686-pc-linux-gnu"
TARGET_ABI="arm-unknown-nto-qnx8.0.0eabi"

#----------------------------------------

# ENVIRONMENT :
source ~/bbndk/bbndk-env_10_3_1_995.sh

#----------------------------------------

# PREPARATION :

mkdir -p "$TARGET_FOLDER/qnx6/usr/"

cp -R ~/bbndk/target_10_3_1_995/qnx6/usr/include/ "$TARGET_FOLDER/qnx6/usr/"

mkdir -p BB10_tools
cd BB10_tools

#----------------------------------------

# DOWNLOAD

git clone https://github.com/extrowerk/bb10-binutils.git
git clone https://github.com/extrowerk/bb10-libmpc.git
git clone https://github.com/extrowerk/bb10-libgmp.git
git clone https://github.com/extrowerk/bb10-libmpfr.git
git clone https://github.com/extrowerk/bb10-gcc.git

#----------------------------------------

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
    --libdir="$HOST_FOLDER/linux/x86/usr/lib" \
    --libexecdir="$HOST_FOLDER/linux/x86/usr/lib" \
    --target="$TARGET_ABI" \
    --prefix="$HOST_FOLDER/linux/x86/usr" \
    --exec-prefix="$HOST_FOLDER/linux/x86/usr" \
    --with-local-prefix="$HOST_FOLDER/linux/x86/usr" \
    --enable-languages=c++ \
    --enable-threads=posix \
    --disable-nls \
    --disable-tls \
    --disable-libssp \
    --disable-libstdcxx-pch \
    --enable-libmudflap \
    --enable-libgomp \
    --enable-__cxa_atexit \
    --with-gxx-include-dir="$TARGET_FOLDER/qnx6/usr/include/c++/8.3.0" \
    --disable-shared \
    --enable-multilib \
    --with-bugurl="http://www.qnx.com" \
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

make -j $CPU_COUNT
make install
cd ..

# ----------------------------------------

# GMP:

mkdir -p bb10-libgmp-build
cd bb10-libgmp-build

../bb10-libgmp/configure \
    --srcdir=../bb10-libgmp \
    --build="$HOST_OS" \
    --enable-cheaders=c \
    --with-as="$TARGET_ABI"-as \
    --with-ld="$TARGET_ABI"-ld \
    --with-sysroot="$TARGET_FOLDER/qnx6/" \
    --disable-werror \
    --libdir="$HOST_FOLDER/linux/x86/usr/lib" \
    --libexecdir="$HOST_FOLDER/linux/x86/usr/lib" \
    --prefix="$HOST_FOLDER/linux/x86/usr" \
    --exec-prefix="$HOST_FOLDER/linux/x86/usr" \
    --with-local-prefix="$HOST_FOLDER/linux/x86/usr" \
    --enable-languages=c++ \
    --enable-threads=posix \
    --disable-nls \
    --disable-tls \
    --disable-libssp \
    --disable-libstdcxx-pch \
    --enable-libmudflap \
    --enable-libgomp \
    --enable-__cxa_atexit \
    --with-gxx-include-dir="$TARGET_FOLDER/qnx6/usr/include/c++/8.3.0" \
    --enable-shared \
    --enable-multilib \
    --with-bugurl=http://www.qnx.com \
    --enable-gnu-indirect-function \
    --enable-stack-protector \
    --with-float=softfp \
    --with-arch=armv7-a \
    --with-fpu=vfpv3-d16 \
    --with-mode=thumb \
    CC="$HOST_CC" \
    LDFLAGS="-Wl,-s " \
    AUTOMAKE=: AUTOCONF=: AUTOHEADER=: AUTORECONF=: ACLOCAL=:

make -j $CPU_COUNT
make install
cd ..

----------------------------------------

# MPC:

mkdir -p bb10-libmpc-build
cd bb10-libmpc-build

../bb10-libmpc/configure \
    --srcdir=../bb10-libmpc \
    --build="$HOST_OS" \
    --with-sysroot="$TARGET_FOLDER/qnx6/" \
    --libdir="$HOST_FOLDER/linux/x86/usr/lib" \
    --libexecdir="$HOST_FOLDER/linux/x86/usr/lib" \
    --target="$TARGET_ABI" \
    --prefix="$HOST_FOLDER/linux/x86/usr" \
    --exec-prefix="$HOST_FOLDER/linux/x86/usr" \
    --enable-shared \
    CC="$HOST_CC" \
    LDFLAGS="-Wl,-s " \
    AUTOMAKE=: AUTOCONF=: AUTOHEADER=: AUTORECONF=: ACLOCAL=:

make -j $CPU_COUNT
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
    --libdir="$HOST_FOLDER/linux/x86/usr/lib" \
    --libexecdir="$HOST_FOLDER/linux/x86/usr/lib" \
    --target="$TARGET_ABI" \
    --prefix="$HOST_FOLDER/linux/x86/usr" \
    --exec-prefix="$HOST_FOLDER/linux/x86/usr" \
    --enable-shared \
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
    --libdir="$HOST_FOLDER/linux/x86/usr/lib" \
    --libexecdir="$HOST_FOLDER/linux/x86/usr/lib" \
    --target="$TARGET_ABI" \
    --prefix="$HOST_FOLDER/linux/x86/usr" \
    --exec-prefix="$HOST_FOLDER/linux/x86/usr" \
    --with-local-prefix="$HOST_FOLDER/linux/x86/usr" \
    --enable-languages=c++ \
    --enable-threads=posix \
    --disable-nls \
    --disable-tls \
    --disable-libssp \
    --disable-libstdcxx-pch \
    --enable-libmudflap \
    --enable-libgomp \
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

