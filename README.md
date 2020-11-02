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

How to use:

1) open a Terminal
2) ```sudo mkdir -p /opt/qnx800```
3) ```sudo chown -R \`whoami\`:\`whoami\` /opt/qnx800```
4) Clone this repo
5) ```chmod +x build.sh``` if required
6) run ```build.sh```
7) Enjoy the matrix!

/-/

We can't update the runtime libs on the phone, but:
- libgcc should be ok, it rarely changes
- you can also link your programs with -static-libgcc so they don't use libgcc_s.so.1 anyway
- the C++ runtime library, libstdc++.so, is however a problem
- link with -static-libstdc++ to not depend on libstdc++.so

Consult the build.sh file for more information.

Have fun! Also send me beer.

BTC: 19NfUaU2Zsaqgvky9g4sQ2WZNPT6556hVp

--extrowerk--
