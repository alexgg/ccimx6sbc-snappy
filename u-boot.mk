include common.mk

DEY_SDK_PATH := /opt/dey/2.0-r3

all: build

clean:
	if test -d "$(UBOOT_SRC)" ; then make clean -C ${UBOOT_SRC}; fi
	rm -f $(UBOOT_BIN)

distclean:
	rm -rf $(wildcard $(UBOOT_SRC))

$(UBOOT_BIN): $(UBOOT_SRC)
	. ${DEY_SDK_PATH}/environment-setup-cortexa9hf-vfp-neon-dey-linux-gnueabi; unset LDFLAGS; $(MAKE) -C $(UBOOT_SRC) ccimx6qsbc_defconfig
	. ${DEY_SDK_PATH}/environment-setup-cortexa9hf-vfp-neon-dey-linux-gnueabi; unset LDFLAGS; $(MAKE) -C $(UBOOT_SRC) -j$(CPUS) CROSS_COMPILE=${CROSS_COMPILE} u-boot.imx
	touch $@

$(UBOOT_SRC):
	git clone --depth=1 $(UBOOT_REPO) -b $(UBOOT_BRANCH)

u-boot: $(UBOOT_BIN)

build: u-boot

.PHONY: u-boot build
