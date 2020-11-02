# bb10-toolchain

/-/

You will need the lates BB NDK:
https://developer.blackberry.com/native/downloads/
Install it in the default folder (eg. ~/bbndk)

And the build-essentials package for your OS. Use your package manager.
You will also need : mpfr, mpc, libgomp, flex, texinfo, autotools, autoconf, autoconf-archive and the respective devel packages. Maybe more.
Tar will be also required.

/-/

The script probably won't be able to create the /opt/qnx800/target/qnx6/usr/ folder structure as a simple user, and you  definetely don't want to run this script as root.
As a workaround you can do the following:

1) open a Terminal
2) ```sudo mkdir -p /opt/qnx800```
3) ```sudo chown -R \`whoami\`:\`whoami\` /opt/qnx800```

/-/

Clone this repo
```chmod +x build.sh``` if required
run ```build.sh```
Enjoy the matrix!

/-/

We can't update the runtime libs on the phone, but:
- libgcc should be ok, it rarely changes
- you can also link your programs with -static-libgcc so they don't use libgcc_s.so.1 anyway
- the C++ runtime library, libstdc++.so, is however a problem
- link with -static-libstdc++ to not depend on libstdc++.so

Consult the build.sh file for more information.

Have fun!
Also send me beer.
BTC: 19NfUaU2Zsaqgvky9g4sQ2WZNPT6556hVp

--extrowerk--
