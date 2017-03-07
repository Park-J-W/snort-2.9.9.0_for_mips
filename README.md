# snort-2.9.9.0 cross compile for mips
- copy to libnl to /opt/altair/toolchain-mips32r2-4kec-uclibc-1351370628/usr/mips-fourgee3100-linux-uclibc/sysroot/usr/lib/
or write the libnl path to snort.mk  

- excuting command : snort -c /etc/snort/snort.conf  --daq pcap --daq-dir /usr/lib/daq --daq-mode passive -i usb0  

- snort.inin is init script for snort.  

- if can't not find *lib.a, then link the paht  
  i.e) ln -s /usr/local/lib/libdnet.1.0.1 /usr/lib/libdnet.1
  or modify --prefix  in the *.mk file as from /usr/local/ to /usr
