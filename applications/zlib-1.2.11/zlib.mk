APP_VER=zlib-1.2.11
zlib_src_dir:=$(applications_src_dir)/$(APP_VER)/src
#zlib_common_src_dir:=$(src_dir)/build/applications/zlib/overlay/etc/config
zlib_dst_dir:=$(applications_dst_dir)/$(APP_VER)
zlib_prefix_dir:=$(rootfs_prepare_dir)/usr

HOST=mips-linux
$(warning ___________________________$(CFLAGS))

$(zlib_dst_dir):
	mkdir -p $@

#add option no-ec_nistp_64_gcc_128 because of FPS verion.
#ifeq ($(if $(wildcard config.log),true,false),false)

zlib-start:
	rm -rf $(zlib_dst_dir)/*; \
	cp -rf $(zlib_src_dir)/* $(zlib_dst_dir); \
	cd $(zlib_dst_dir) ; \
	CC=$(CON_CC) ./configure --prefix=$(zlib_prefix_dir); \
	cd - 
#./configure CC="$(CC)" --build=mips-linux --host=$(HOST) --prefix=$(zlib_prefix_dir) --with-libpcap-libraries=$(libpcap_dir); \
 
zlib: $(zlib_dst_dir) zlib-start
	SRC_DIR=$(zlib_src_dir) \
	DST_DIR=$(zlib_dst_dir) \
	CC="$(CC)" \
	AR="$(AR)" \
	LD="$(LD)" \
	NM="$(NM)" \
	AS="$(AS)" \
	RANLIB="$(RANLIB)" \
	CFLAGS="$(CFLAGS)" \
	LDFLAGS="$(LDFLAGS)" \
	make -C $(zlib_dst_dir);
#	cp -rf $(zlib_dst_dir)/lib/.libs/zlib.* $(zlib_dst_dir);
 
zlib-install:
	make -C $(zlib_dst_dir) install;
	@echo $(zlib_prefix_dir);
	@echo $(zlib_common_src_dir);
#mkdir -p $(zlib_common_src_dir);
#	cp -rf $(zlib_prefix_dir)/zlib.cnf $(zlib_common_src_dir);
#	cp -rf $(zlib_prefix_dir)/certs $(zlib_common_src_dir);
#	cp -rf $(zlib_prefix_dir)/private $(zlib_common_src_dir);
	
zlib-uninstall:
	SRC_DIR=$(zlib_src_dir) \
	DST_DIR=$(zlib_dst_dir) \
	INSTALL_METHOD=$(APP_INSTALL_METHOD) \
	INSTALL_PREFIX=$(APP_INSTALL_PREFIX) \
	make -C $(zlib_dst_dir) uninstall

zlib-clean: $(zlib_dst_dir) 
	SRC_DIR=$(zlib_src_dir) \
	DST_DIR=$(zlib_dst_dir) \
	INSTALL_METHOD=$(APP_INSTALL_METHOD) \
	INSTALL_PREFIX=$(APP_INSTALL_PREFIX) \
	CC="$(CC)" \
	make -C $(zlib_dst_dir) clean

zlib-distclean: $(zlib_dst_dir) 
	SRC_DIR=$(zlib_src_dir) \
	DST_DIR=$(zlib_dst_dir) \
	INSTALL_METHOD=$(APP_INSTALL_METHOD) \
	INSTALL_PREFIX=$(APP_INSTALL_PREFIX) \
	CC="$(CC)" \
	make -C $(zlib_dst_dir) distclean

APPLICATION_TARGETS += zlib
