APP_VER=daq-2.0.6
daq_src_dir:=$(applications_src_dir)/$(APP_VER)/src
#daq_common_src_dir:=$(src_dir)/build/applications/daq/overlay/etc/config
daq_dst_dir:=$(applications_dst_dir)/$(APP_VER)
daq_prefix_dir:=$(rootfs_prepare_dir)/usr/local
libpcap_dir:=$(rootfs_prepare_dir)/../devpack/usr/lib
dnet_lib_dir:=$(daq_prefix_dir)/../lib
dnet_inc_dir:=$(applications_dst_dir)/libdnet-1.11/include

T_HOST=mips-linux

$(daq_dst_dir):
	mkdir -p $@

#add option no-ec_nistp_64_gcc_128 because of FPS verion.
#ifeq ($(if $(wildcard config.log),true,false),false)

#	--with-dnet-includes=DIR    dnet include directory
#	  --with-dnet-libraries=DIR

# ac_cv_func_malloc_0_nonnull=yes means  ERROR!  daq_static library not found, go get it from ....
# the ERROR occurs compiling snort. detaile Error is below in the config.log file.
# undefined reference to `rpl_malloc'

daq-start:
	rm -rf $(daq_dst_dir)/*; \
	cp -rf $(daq_src_dir)/* $(daq_dst_dir); \
	cd $(daq_dst_dir) ; \
	autoconf -i -f; \
	touch Makefile; \
	ac_cv_func_malloc_0_nonnull=yes CFLAGS+=-fPIC ./configure CC="$(CC)" --build=x86_64-unknown-linux-gnu --target=$(T_HOST) --host=$(T_HOST) --prefix=$(daq_prefix_dir) --with-libpcap-libraries=$(libpcap_dir) --with-dnet-libraries=$(dnet_lib_dir) --with-dnet-includes=$(dnet_inc_dir); \
	cd -;
#./configure CC="$(CC)" --build=mips-linux --host=$(HOST) --prefix=$(daq_prefix_dir) --with-libpcap-libraries=$(libpcap_dir); \
 
daq: $(daq_dst_dir) daq-start
	SRC_DIR=$(daq_src_dir) \
	DST_DIR=$(daq_dst_dir) \
	CC="$(CC)" \
	AR="$(AR)" \
	LD="$(LD)" \
	NM="$(NM)" \
	AS="$(AS)" \
	RANLIB="$(RANLIB)" \
	CFLAGS="$(CFLAGS)" \
	LDFLAGS="$(LDFLAGS)" \
	make -C $(daq_dst_dir);
	make -C $(daq_dst_dir) install;
#	cp -rf $(daq_dst_dir)/lib/.libs/daq.* $(daq_dst_dir);
 
daq-install:
	make -C $(daq_dst_dir) install;
	@echo $(daq_prefix_dir);
	@echo $(daq_common_src_dir);
#mkdir -p $(daq_common_src_dir);
#	cp -rf $(daq_prefix_dir)/daq.cnf $(daq_common_src_dir);
#	cp -rf $(daq_prefix_dir)/certs $(daq_common_src_dir);
#	cp -rf $(daq_prefix_dir)/private $(daq_common_src_dir);
	
daq-uninstall:
	SRC_DIR=$(daq_src_dir) \
	DST_DIR=$(daq_dst_dir) \
	INSTALL_METHOD=$(APP_INSTALL_METHOD) \
	INSTALL_PREFIX=$(APP_INSTALL_PREFIX) \
	make -C $(daq_dst_dir) uninstall

daq-clean: $(daq_dst_dir) 
	SRC_DIR=$(daq_src_dir) \
	DST_DIR=$(daq_dst_dir) \
	INSTALL_METHOD=$(APP_INSTALL_METHOD) \
	INSTALL_PREFIX=$(APP_INSTALL_PREFIX) \
	CC="$(CC)" \
	make -C $(daq_dst_dir) clean

daq-distclean: $(daq_dst_dir) 
	SRC_DIR=$(daq_src_dir) \
	DST_DIR=$(daq_dst_dir) \
	INSTALL_METHOD=$(APP_INSTALL_METHOD) \
	INSTALL_PREFIX=$(APP_INSTALL_PREFIX) \
	CC="$(CC)" \
	make -C $(daq_dst_dir) distclean

APPLICATION_TARGETS += daq
