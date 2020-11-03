# bb10-toolchain

![Proof](https://raw.githubusercontent.com/extrowerk/bb10-toolchain/master/2020-11-02-210811_861x137_scrot.png)

/-/

You will need the lates BB NDK:
https://developer.blackberry.com/native/downloads/
Install it in the default folder (eg. ~/bbndk)

And the build-essentials package for your OS. Use your package manager.
You will also need : mpfr, mpc, libgomp, flex, texinfo, autotools, autoconf, autoconf-archive and the respective devel packages. Maybe more.
Tar will be also required.

/-/

How to build:

1) open a Terminal
2) ```sudo mkdir -p /opt/qnx800```
3) ```sudo chown -R \`whoami\`:\`whoami\` /opt/qnx800```
4) Clone this repo
5) ```chmod +x build.sh``` if required
6) run ```build.sh```
7) Enjoy the matrix!

/-/

How to use:

Source the environment vars:
```
source ~/bbndk/bbndk-env_10_3_1_995.sh
```

Compiling a C program:
```
/opt/qnx800/host/linux/x86_64/usr/bin/arm-unknown-nto-qnx8.0.0eabi-gcc test.c -o test
```

Compiling a C++ program:
```
/opt/qnx800/host/linux/x86_64/usr/bin/arm-unknown-nto-qnx8.0.0eabi-g++ hello.cpp -o hello_cpp -I/opt/qnx800/target/qnx6/usr/include/c++/5.4.0 -I/opt/qnx800/target/qnx6/usr/include/c++/5.4.0/arm-unknown-nto-qnx8.0.0eabi -L/opt/qnx800/host/linux/x86_64/usr/arm-unknown-nto-qnx8.0.0eabi/lib -static
```
Consider passing -static too to remove the runtime dependency.

Compiling an auto* package:
```
CC=/opt/qnx800/host/linux/x86_64/usr/bin/arm-unknown-nto-qnx8.0.0eabi-gcc CPP=/opt/qnx800/host/linux/x86_64/usr/bin/arm-unknown-nto-qnx8.0.0eabi-cpp ./configure --host=arm-unknown-nto-qnx8.0.0eabi --prefix=/some/where
```
or
```
CC=/opt/qnx800/host/linux/x86_64/usr/bin/arm-unknown-nto-qnx8.0.0eabi-gcc CPP=/opt/qnx800/host/linux/x86_64/usr/bin/arm-unknown-nto-qnx8.0.0eabi-cpp ./configure --target=arm-unknown-nto-qnx8.0.0eabi --prefix=/some/where
```
or
```
./configure  --prefix=/home/szilard/Asztal/00000/PORTS/ --cc=/opt/qnx800/host/linux/x86_64/usr/bin/arm-unknown-nto-qnx8.0.0eabi-gcc --cxx=/opt/qnx800/host/linux/x86_64/usr/bin/arm-unknown-nto-qnx8.0.0eabi-g++ --enable-cross-compile
```
I wish i was joking. GNU was a mistake.

/-/

We can't update the runtime libs on the phone, but:
- libgcc should be ok, it rarely changes (Checked, seems to be true)
- you can also link your programs with -static-libgcc so they don't use libgcc_s.so.1 anyway
- the C++ runtime library, libstdc++.so, is however a problem (Checked, the compiled mini-program works on the phone)
- link with -static-libstdc++ to not depend on libstdc++.so

Consult the build.sh file for more information.

Have fun! Also send me beer.

BTC: 19NfUaU2Zsaqgvky9g4sQ2WZNPT6556hVp

--extrowerk--
