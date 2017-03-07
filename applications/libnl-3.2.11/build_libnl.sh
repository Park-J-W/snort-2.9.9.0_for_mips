#!/bin/sh

. ../pltsetup.sh

make distclean
./configure --host=mips-unknown-linux
make

if [ "$TFTP_DIR" != "" ] ; then
	echo "Copying files to $TFTP_DIR"
	cp lib/.libs/libnl-3.so.200 $TFTP_DIR
	cp lib/.libs/libnl-genl-3.so.200 $TFTP_DIR
fi

