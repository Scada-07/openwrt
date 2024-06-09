PKG_DRIVERS += \
uwe5622 \

config-$(call config_package,uwe5622) += \
WLAN_UWE5622 \
SPRDWL_NG \

config-y += \
WCN_BSP_DRIVER_BUILDIN \
AW_WIFI_DEVICE_UWE5622 \
AW_BIND_VERIFY \

define KernelPackage/uwe5622
  $(call KernelPackage/mac80211/Default)
  TITLE:= UWE5622(AW859A) Wireless Driver
  DEPENDS+= +kmod-mac80211 +kmod +kmod-mmc +@DRIVER_11AC_SUPPORT +kmod-sunxi-rfkill
  FILES:= \
    $(PKG_BUILD_DIR)/drivers/net/wireless/uwe5622/unisocwifi/sprdwl_ng.ko \
    $(PKG_BUILD_DIR)/drivers/net/wireless/uwe5622/unisocwcn/uwe5622_bsp_sdio.ko \
    $(PKG_BUILD_DIR)/drivers/net/wireless/sunxi-rfkill/sunxi_rfkill.ko
  AUTOLOAD:=$(call AutoProbe,sprdwl_ng)
endef

