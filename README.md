# bb10-toolchain

Work in progress!

You will need the lates BB NDK:
https://developer.blackberry.com/native/downloads/

-

The script probably won't be able to create the /opt/qnx800/target/qnx6/usr/ folder structure as a simple user, and you  definetely don't want to run this script as root.
As a workaround you can do the following:

1) open a Terminal
2) sudo mkdir -p /opt/qnx800/target/qnx6/usr/
3) sudo chown -R \`whoami\`:\`whoami\` /opt/qnx800

-

Consult the build.sh file for more information.

Have fun!
