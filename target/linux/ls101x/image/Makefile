#
# Copyright (C) 2013 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

BD_NAME = ls1012a-rdb

define Image/BuildKernel
	# generate kernel & dtb FIT image
	$(CP) kernel-$(BD_NAME).its $(KDIR)/kernel-$(BD_NAME).its
	$(CP) $(LINUX_DIR)/arch/arm64/boot/dts/fsl-$(BD_NAME).dtb $(KDIR)/fsl-$(BD_NAME).dtb	
	PATH=$(LINUX_DIR)/scripts/dtc:$(PATH) \
		mkimage -f $(KDIR)/kernel-$(BD_NAME).its $(KDIR)/kernel-$(BD_NAME).itb
	$(CP) $(KDIR)/kernel-$(BD_NAME).itb $(BIN_DIR)/$(IMG_PREFIX)-$(BD_NAME)-kernel.itb

	# generate ramdisk rootfs
    ifneq ($(CONFIG_TARGET_ROOTFS_INITRAMFS)$(CONFIG_INITRAMFS_COMPRESSION_GZIP),)
		mkimage -A arm64 -O linux -T ramdisk -C gzip -a 0x00000000 -e 0x00000000 \
			-n 'ARM64 OpenWrt Linux-$(LINUX_VERSION)' -d $(LINUX_DIR)/usr/initramfs_data.cpio.gz \
			$(BIN_DIR)/$(IMG_PREFIX)-rootfs.ramfs
    
		# generate kernel & dtb & ramdisk FIT image
		$(CP) kernel-ramdisk-$(BD_NAME).its $(KDIR)/kernel-ramdisk-$(BD_NAME).its
		$(CP) $(LINUX_DIR)/usr/initramfs_data.cpio.gz $(KDIR)/initramfs_data.cpio.gz
		PATH=$(LINUX_DIR)/scripts/dtc:$(PATH) \
			mkimage -f $(KDIR)/kernel-ramdisk-$(BD_NAME).its $(KDIR)/kernel-ramdisk-$(BD_NAME).itb
		$(CP) $(KDIR)/kernel-ramdisk-$(BD_NAME).itb $(BIN_DIR)/$(IMG_PREFIX)-$(BD_NAME)-kernel-ramfs.itb
    endif
endef

define Image/InstallKernel
endef

ifneq ($(CONFIG_TARGET_ROOTFS_SQUASHFS),)
	# generate squashfs rootfs for NOR flash usage
    define Image/Build/squashfs
		$(call prepare_generic_squashfs,$(KDIR)/root.$(1))
		dd if=$(KDIR)/root.$(1) of=$(BIN_DIR)/$(IMG_PREFIX)-rootfs.$(1) bs=128k conv=sync

		# cat squashfs to the end of kernel FIT image
		cat $(BIN_DIR)/$(IMG_PREFIX)-$(BD_NAME)-kernel.itb \
			$(BIN_DIR)/$(IMG_PREFIX)-rootfs.$(1) \
			> $(BIN_DIR)/$(IMG_PREFIX)-$(BD_NAME)-kernel-squashfs.itb
    endef
endif

ifneq ($(CONFIG_TARGET_ROOTFS_CPIOGZ)$(CONFIG_INITRAMFS_COMPRESSION_GZIP),)
    define Image/mkfs/cpiogz
		$(CP) $(LINUX_DIR)/usr/initramfs_data.cpio.gz $(BIN_DIR)/$(IMG_PREFIX)-rootfs.cpio.gz
    endef
endif

ifneq ($(CONFIG_TARGET_ROOTFS_TARGZ),)
    define Image/mkfs/targz
		$(TAR) -czpf $(BIN_DIR)/$(IMG_PREFIX)-rootfs.tar.gz --numeric-owner --owner=0 --group=0 -C $(TARGET_DIR)/ .
    endef
endif

define Image/Build
	$(call Image/Build/$(1),$(1))
endef

$(eval $(call BuildImage))
