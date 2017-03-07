libnl_src_dir:=$(applications_src_dir)/libnl-3.2.11/
libnl_common_src_dir:=$(src_dir)/build/applications/libnl-3.2.11
libnl_dst_dir:=$(applications_dst_dir)/libnl-3.2.11

ifeq ("$(AC_TOOLCHAIN_4KEC)", "y")
HOST = mips-fourgee3100-linux-uclibc
else
HOST = mips-linux-gnu
CFLAG += -msoft-float -mtune=34kc -EB
endif

$(libnl_dst_dir):
	mkdir -p $@

libnl-start:
	cp -r $(libnl_src_dir)/* $(libnl_dst_dir); \
	chmod -R 777 $(libnl_dst_dir); \
        make -C $(libnl_dst_dir) distclean ; \
	cd  $(libnl_dst_dir) ; \
	./configure --host=$(HOST) ; \
	cd -
 
libnl: $(libnl_dst_dir) libnl-start apps_common
	SRC_DIR=$(libnl_src_dir) \
	DST_DIR=$(libnl_dst_dir) \
	APP_COMMON_SRC_DIR=$(apps_common_src_dir) \
	APP_COMMON_DST_DIR=$(apps_common_dst_dir) \
	CC="$(HOST)"-gcc \
	CFLAGS="$(CFLAGS)" \
	LDFLAGS="$(LDFLAGS)" \
	make -C $(libnl_dst_dir);
 
libnl-install:
	mkdir -p $(libnl_common_src_dir)/overlay/lib ;
	cp $(libnl_dst_dir)/lib/.libs/libnl-3.so $(libnl_common_src_dir)/overlay/lib ;
	cp $(libnl_dst_dir)//lib/.libs/libnl-genl-3.so.200 $(libnl_common_src_dir)/overlay/lib ;
	$(call install, $(libnl_common_src_dir)/overlay/*, /, cp -rf)
	

libnl-uninstall:
	SRC_DIR=$(libnl_src_dir) \
	DST_DIR=$(libnl_dst_dir) \
	INSTALL_METHOD=$(APP_INSTALL_METHOD) \
	INSTALL_PREFIX=$(APP_INSTALL_PREFIX) \
	make -C $(libnl_src_dir) uninstall

libnl-clean: $(libnl_dst_dir) apps_common
	SRC_DIR=$(libnl_src_dir) \
	DST_DIR=$(libnl_dst_dir) \
	INSTALL_METHOD=$(APP_INSTALL_METHOD) \
	INSTALL_PREFIX=$(APP_INSTALL_PREFIX) \
	CC="$(CC)" \
	make -C $(libnl_src_dir) clean

APPLICATION_TARGETS += libnl
