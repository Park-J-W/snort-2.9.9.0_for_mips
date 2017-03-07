APP_VER=snort-2.9.9.0
snort_src_dir:=$(applications_src_dir)/$(APP_VER)/src
#snort_common_src_dir:=$(src_dir)/build/applications/snort/overlay/etc/config
snort_dst_dir:=$(applications_dst_dir)/$(APP_VER)
#By default, `make install' will install all the files in `/usr/local/bin', `/usr/local/lib' etc.
snort_prefix_dir:=$(rootfs_prepare_dir)/usr/local
libpcap_dir:=$(rootfs_prepare_dir)/../devpack/usr/lib
incpcap_dir:=$(rootfs_prepare_dir)/../devpack/usr/include
pcre_inc_dir:=$(applications_dst_dir)/pcre-8.34
dnet_inc_dir:=$(applications_dst_dir)/libdnet-1.11/include
#dnet_lib_dir:=$(applications_dst_dir)/libdnet-1.11/src/.libs
dnet_lib_dir:=$(snort_prefix_dir)/../lib
daq_lib_dir:=$(snort_prefix_dir)/lib
# because of ERROR!  daq library missing C99 patch, must include below.
daq_inc_dir:=$(snort_prefix_dir)/include
openssl_lib_dir:=$(applications_dst_dir)/openssl

HOST=mips-fourgee3100-linux-uclibc
#HOST=mips-linux

# CC="mips-fourgee3100-linux-uclibc-gcc --sysroot=/opt/altair/toolchain-mips32r2-4kec-uclibc-1351370628/usr/mips-fourgee3100-linux-uclibc/sysroot"
# Altair CC includes cross compiler and sysroot. so in case of snort configure, it must be separated.
CON_CC=$(word 1, $(CC))
TMP_CON_SYSROOT=$(word 2, $(CC))
CON_SYSROOT=$(subst --sysroot=,,$(TMP_CON_SYSROOT))

$(warning ___________________________LD_LIBRARY_PATH = $(LD_LIBRARY_PATH))
$(warning ___________________________LDFLAGS = $(LDFLAGS))
$(warning ___________________________CPPFLAGS = $(CPPFLAGS))
#	autoconf -f -i; \

# ./configure: line 15492: daq-modules-config: command not found
# daq-modules-config must be installed to below PATH. it means daq must be installed before run the snort configure.
PATH:=$(PATH):$(snort_prefix_dir)/bin
$(warning ___________________________$@)

$(snort_dst_dir):
	mkdir -p $@

#add option no-ec_nistp_64_gcc_128 because of FPS verion.
#ifeq ($(if $(wildcard config.log),true,false),false) 

# LDFLAGS="-L$(openssl_lib_dir) $(LDFLAGS)"
# -->  /opt/altair/toolchain-mips32r2-4kec-uclibc-1351370628/usr/bin/../lib/gcc/mips-fourgee3100-linux-uclibc/4.5.3/../../../../mips-fourgee3100-linux-uclibc/bin/ld: /home/jjong/work/ALT3800/NTLR210/build/rootfs.pre/../devpack/usr/lib/libcrypto.so(md5_one.o): relocation R_MIPS_HI16 against `__gnu_local_gp' can not be used when making a shared object; recompile with -fPIC
#/home/jjong/work/ALT3800/NTLR210/build/rootfs.pre/../devpack/usr/lib/libcrypto.so: could not read symbols: Bad value <--
# because of above Error, LDFLAGS="-L$(openssl_lib_dir) $(LDFLAGS)" was added.
# libcrypto.so is two paht. one is devpack/usr/lib. other one is build/applications/openssl.
# First was provided from Altair without -fPIC option. Second built by ntmore with -fPIC option.
# first parameter of LDFLAGS is devpack/usr/lib. So buiding find the libcrypto.so to devpack/usr/lib.
snort-start:
	rm -rf $(snort_dst_dir)/*; \
	cp -rf $(snort_src_dir)/* $(snort_dst_dir); \
	cd $(snort_dst_dir) ; \
	touch Makefile; \
	LDFLAGS="-L$(openssl_lib_dir) $(LDFLAGS)" ./configure CC="$(CON_CC)" PKG_CONFIG_PATH=$(pkg_config_dir) --build=x86_64-unknown-linux-gnu --target=$(HOST) --host=$(HOST) --prefix=$(snort_prefix_dir) --with-sysroot=$(CON_SYSROOT) --with-libpcap-libraries=$(libpcap_dir) --with-libpcap-includes=$(incpcap_dir) --with-libpcre-includes=$(pcre_inc_dir) --with-dnet-includes=$(dnet_inc_dir) --with-dnet-libraries=$(dnet_lib_dir) --with-daq-libraries=$(daq_lib_dir) --with-daq-includes=$(daq_inc_dir) --with-openssl-libraries=$(openssl_lib_dir); \
	cd - 
 
snort: $(snort_dst_dir) snort-start
	SRC_DIR=$(snort_src_dir) \
	DST_DIR=$(snort_dst_dir) \
	CC="$(CC)" \
	AR="$(AR)" \
	LD="$(LD)" \
	NM="$(NM)" \
	AS="$(AS)" \
	RANLIB="$(RANLIB)" \
	CFLAGS="$(CFLAGS)" \
	LDFLAGS="$(LDFLAGS)" \
	make -C $(snort_dst_dir);
#	cp -rf $(snort_dst_dir)/lib/.libs/snort.* $(snort_dst_dir);
 
snort-install:
	make -C $(snort_dst_dir) install;
	@echo $(snort_prefix_dir);
	@echo $(snort_common_src_dir);
#mkdir -p $(snort_common_src_dir);
#	cp -rf $(snort_prefix_dir)/snort.cnf $(snort_common_src_dir);
#	cp -rf $(snort_prefix_dir)/certs $(snort_common_src_dir);
#	cp -rf $(snort_prefix_dir)/private $(snort_common_src_dir);
	
snort-uninstall:
	SRC_DIR=$(snort_src_dir) \
	DST_DIR=$(snort_dst_dir) \
	INSTALL_METHOD=$(APP_INSTALL_METHOD) \
	INSTALL_PREFIX=$(APP_INSTALL_PREFIX) \
	make -C $(snort_dst_dir) uninstall

snort-clean: $(snort_dst_dir) 
	SRC_DIR=$(snort_src_dir) \
	DST_DIR=$(snort_dst_dir) \
	INSTALL_METHOD=$(APP_INSTALL_METHOD) \
	INSTALL_PREFIX=$(APP_INSTALL_PREFIX) \
	CC="$(CC)" \
	make -C $(snort_dst_dir) clean

snort-distclean: $(snort_dst_dir) 
	SRC_DIR=$(snort_src_dir) \
	DST_DIR=$(snort_dst_dir) \
	INSTALL_METHOD=$(APP_INSTALL_METHOD) \
	INSTALL_PREFIX=$(APP_INSTALL_PREFIX) \
	CC="$(CC)" \
	make -C $(snort_dst_dir) distclean

APPLICATION_TARGETS += snort
