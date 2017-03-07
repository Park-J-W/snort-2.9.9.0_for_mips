APP_VER=libdnet-1.11
libdnet_src_dir:=$(applications_src_dir)/$(APP_VER)/src
#libdnet_common_src_dir:=$(src_dir)/build/applications/libdnet/overlay/etc/config
libdnet_dst_dir:=$(applications_dst_dir)/$(APP_VER)
libdnet_prefix_dir:=$(rootfs_prepare_dir)/usr

T_HOST=mips-linux

$(libdnet_dst_dir):
	mkdir -p $@

#add option no-ec_nistp_64_gcc_128 because of FPS verion.
#ifeq ($(if $(wildcard config.log),true,false),false)

libdnet-start:
	rm -rf $(libdnet_dst_dir)/*; \
	cp -rf $(libdnet_src_dir)/* $(libdnet_dst_dir); \
	cd $(libdnet_dst_dir) ; \
	touch Makefile; \
	CFLAGS+=-fPIC ./configure CC="$(CC)" --build=x86_64-unknown-linux-gnu --target=$(T_HOST) --host=$(T_HOST) --prefix=$(libdnet_prefix_dir) --disable-gtk-doc --disable-doc --disable-docs --disable-documentation --enable-shared --enable-static; \
	cd - 
#./configure CC="$(CC)" --build=mips-linux --host=$(HOST) --prefix=$(libdnet_prefix_dir) --with-libpcap-libraries=$(libpcap_dir); \
 
libdnet: $(libdnet_dst_dir) libdnet-start
	SRC_DIR=$(libdnet_src_dir) \
	DST_DIR=$(libdnet_dst_dir) \
	CC="$(CC)" \
	AR="$(AR)" \
	LD="$(LD)" \
	NM="$(NM)" \
	AS="$(AS)" \
	RANLIB="$(RANLIB)" \
	CFLAGS="$(CFLAGS)" \
	LDFLAGS="$(LDFLAGS)" \
	make -C $(libdnet_dst_dir);
	make -C $(libdnet_dst_dir) install;
#	cp -rf $(libdnet_dst_dir)/lib/.libs/libdnet.* $(libdnet_dst_dir);
 
libdnet-install:
#make -C $(libdnet_dst_dir) install;
#	@echo $(libdnet_prefix_dir);
#	@echo $(libdnet_common_src_dir);
#mkdir -p $(libdnet_common_src_dir);
#	cp -rf $(libdnet_prefix_dir)/libdnet.cnf $(libdnet_common_src_dir);
#	cp -rf $(libdnet_prefix_dir)/certs $(libdnet_common_src_dir);
#	cp -rf $(libdnet_prefix_dir)/private $(libdnet_common_src_dir);
	
libdnet-uninstall:
	SRC_DIR=$(libdnet_src_dir) \
	DST_DIR=$(libdnet_dst_dir) \
	INSTALL_METHOD=$(APP_INSTALL_METHOD) \
	INSTALL_PREFIX=$(APP_INSTALL_PREFIX) \
	make -C $(libdnet_dst_dir) uninstall

libdnet-clean: $(libdnet_dst_dir) 
	SRC_DIR=$(libdnet_src_dir) \
	DST_DIR=$(libdnet_dst_dir) \
	INSTALL_METHOD=$(APP_INSTALL_METHOD) \
	INSTALL_PREFIX=$(APP_INSTALL_PREFIX) \
	CC="$(CC)" \
	make -C $(libdnet_dst_dir) clean

libdnet-distclean: $(libdnet_dst_dir) 
	SRC_DIR=$(libdnet_src_dir) \
	DST_DIR=$(libdnet_dst_dir) \
	INSTALL_METHOD=$(APP_INSTALL_METHOD) \
	INSTALL_PREFIX=$(APP_INSTALL_PREFIX) \
	CC="$(CC)" \
	make -C $(libdnet_dst_dir) distclean

APPLICATION_TARGETS += libdnet
