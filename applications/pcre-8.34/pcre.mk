APP_VER=pcre-8.34
pcre_src_dir:=$(applications_src_dir)/$(APP_VER)/src
#pcre_common_src_dir:=$(src_dir)/build/applications/pcre/overlay/etc/config
pcre_dst_dir:=$(applications_dst_dir)/$(APP_VER)
pcre_prefix_dir:=$(rootfs_prepare_dir)/usr/local

HOST=mips-linux

$(pcre_dst_dir):
	mkdir -p $@

#add option no-ec_nistp_64_gcc_128 because of FPS verion.
#ifeq ($(if $(wildcard config.log),true,false),false)

pcre-start:
	rm -rf $(pcre_dst_dir)/*; \
	cp -rf $(pcre_src_dir)/* $(pcre_dst_dir); \
	cd $(pcre_dst_dir) ; \
	touch Makefile; \
	./configure CC="$(CC)" --build=x86_64-unknown-linux-gnu --target=$(HOST) --host=$(HOST) --prefix=$(pcre_prefix_dir) --disable-gtk-doc --disable-doc --disable-docs --disable-documentation --enable-shared --enable-static; \
	cd - 
#./configure CC="$(CC)" --build=mips-linux --host=$(HOST) --prefix=$(pcre_prefix_dir) --with-libpcap-libraries=$(libpcap_dir); \
 
pcre: $(pcre_dst_dir) pcre-start
	SRC_DIR=$(pcre_src_dir) \
	DST_DIR=$(pcre_dst_dir) \
	CC="$(CC)" \
	AR="$(AR)" \
	LD="$(LD)" \
	NM="$(NM)" \
	AS="$(AS)" \
	RANLIB="$(RANLIB)" \
	CFLAGS="$(CFLAGS)" \
	LDFLAGS="$(LDFLAGS)" \
	make -C $(pcre_dst_dir);
#./configure: line 14850: pcre-config: command not found
	make -C $(pcre_dst_dir) install;
 
pcre-install:
#	make -C $(pcre_dst_dir) install;
#	@echo $(pcre_prefix_dir);
#	@echo $(pcre_common_src_dir);
#mkdir -p $(pcre_common_src_dir);
#	cp -rf $(pcre_prefix_dir)/pcre.cnf $(pcre_common_src_dir);
#	cp -rf $(pcre_prefix_dir)/certs $(pcre_common_src_dir);
#	cp -rf $(pcre_prefix_dir)/private $(pcre_common_src_dir);
	
pcre-uninstall:
	SRC_DIR=$(pcre_src_dir) \
	DST_DIR=$(pcre_dst_dir) \
	INSTALL_METHOD=$(APP_INSTALL_METHOD) \
	INSTALL_PREFIX=$(APP_INSTALL_PREFIX) \
	make -C $(pcre_dst_dir) uninstall

pcre-clean: $(pcre_dst_dir) 
	SRC_DIR=$(pcre_src_dir) \
	DST_DIR=$(pcre_dst_dir) \
	INSTALL_METHOD=$(APP_INSTALL_METHOD) \
	INSTALL_PREFIX=$(APP_INSTALL_PREFIX) \
	CC="$(CC)" \
	make -C $(pcre_dst_dir) clean

pcre-distclean: $(pcre_dst_dir) 
	SRC_DIR=$(pcre_src_dir) \
	DST_DIR=$(pcre_dst_dir) \
	INSTALL_METHOD=$(APP_INSTALL_METHOD) \
	INSTALL_PREFIX=$(APP_INSTALL_PREFIX) \
	CC="$(CC)" \
	make -C $(pcre_dst_dir) distclean

APPLICATION_TARGETS += pcre
