include common.mk

DEY_SDK_PATH := /opt/dey/2.0-r3

all: build

clean:
	if test -d "$(LINUX_SRC)" ; then $(MAKE) -C $(LINUX_SRC) mrproper ; fi
	rm -f $(INITRD_IMG) $(LINUX_UIMAGE) $(LINUX_DTB)
	rm -rf $(LINUX_MODULES)

distclean:
	rm -rf $(wildcard $(LINUX_SRC) $(INITRD_SRC))

$(LINUX_SRC):
	@git clone --depth=1 $(LINUX_REPO) -b $(LINUX_BRANCH) linux

$(LINUX_SRC)/.config: $(LINUX_SRC)
	. ${DEY_SDK_PATH}/environment-setup-cortexa9hf-vfp-neon-dey-linux-gnueabi; unset LDFLAGS;$(MAKE) -C $(LINUX_SRC) ccimx6sbc_defconfig

$(LINUX_UIMAGE): $(LINUX_SRC)/.config
	@rm -f $(LINUX_UIMAGE)
	. ${DEY_SDK_PATH}/environment-setup-cortexa9hf-vfp-neon-dey-linux-gnueabi; unset LDFLAGS;$(MAKE) -C $(LINUX_SRC) -j$(CPUS) LOADADDR=0x10800000 uImage

$(LINUX_DTB): $(LINUX_SRC)/.config
	. ${DEY_SDK_PATH}/environment-setup-cortexa9hf-vfp-neon-dey-linux-gnueabi; unset LDFLAGS;$(MAKE) -C $(LINUX_SRC) -j$(CPUS) dtbs

config: $(LINUX_SRC)/.config

kernel: $(LINUX_UIMAGE)

dtb: $(LINUX_DTB)

modules: $(LINUX_SRC)/.config
	. ${DEY_SDK_PATH}/environment-setup-cortexa9hf-vfp-neon-dey-linux-gnueabi; unset LDFLAGS;$(MAKE) -C $(LINUX_SRC) -j$(CPUS) modules

linux: kernel dtb modules
	@rm -rf $(LINUX_MODULES)
	. ${DEY_SDK_PATH}/environment-setup-cortexa9hf-vfp-neon-dey-linux-gnueabi; unset LDFLAGS;$(MAKE) -C $(LINUX_SRC) -j$(CPUS) INSTALL_MOD_PATH=$(LINUX_MODULES) INSTALL_MOD_STRIP=1 modules_install

build: linux

.PHONY: kernel dtb modules linux build
