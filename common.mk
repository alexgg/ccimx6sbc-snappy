CPUS := $(shell getconf _NPROCESSORS_ONLN)

OUTPUT_DIR := $(PWD)

UBOOT_REPO := https://github.com/digi-embedded/u-boot.git
UBOOT_BRANCH := v2015.04/maint
UBOOT_SRC := $(PWD)/u-boot
UBOOT_BIN := $(UBOOT_SRC)/u-boot.imx
UBOOT_MKENVIMAGE := $(UBOOT_SRC)/tools/mkenvimage

LINUX_REPO := https://github.com/digi-embedded/linux.git
LINUX_BRANCH := v3.14/dey-2.0/maint
LINUX_SRC := $(PWD)/linux
LINUX_UIMAGE := $(LINUX_SRC)/arch/arm/boot/uImage
LINUX_DTB := $(LINUX_SRC)/arch/arm/boot/dts/imx6q-ccimx6sbc-wb.dtb
LINUX_MODULES := $(LINUX_SRC)/modules

