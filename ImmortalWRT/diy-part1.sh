#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Uncomment a feed source
# sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source


sed -i '1isrc-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '2isrc-git small https://github.com/kenzok8/small' feeds.conf.default
sed -i '3isrc-git zzz https://github.com/blueberry-pie-11/luci-app-natmap'  feeds.conf.default

# 添加iptables-mod-socket
cp -rf $GITHUB_WORKSPACE/patches/5.4/iptables-mod-socket.patch $GITHUB_WORKSPACE/openwrt/package/iptables-mod-socket.patch
patch -p1 < $GITHUB_WORKSPACE/openwrt/package/iptables-mod-socket.patch

# 添加 kmod-nf-tproxy 依赖
sed -i 's/DEPENDS\+=+kmod-ipt-conntrack +IPV6:kmod-nf-conntrack6/DEPENDS\+=+kmod-nf-tproxy +kmod-nf-conntrack +IPV6:kmod-nf-conntrack6/' package/kernel/linux/modules/netfilter.mk

# 添加 ipt-socket 依赖
sed -i '/$(eval $(call KernelPackage,ipt-led))/a \
\
define KernelPackage/ipt-socket\n\
  TITLE:=Iptables socket matching support\n\
  DEPENDS+=+kmod-nf-socket +kmod-nf-conntrack +IPV6:kmod-nf-conntrack6\n\
  KCONFIG:=$(KCONFIG_IPT_SOCKET)\n\
  FILES:=$(foreach mod,$(IPT_SOCKET-m),$(LINUX_DIR)/net/$(mod).ko)\n\
  AUTOLOAD:=$(call AutoProbe,$(notdir $(IPT_SOCKET-m)))\n\
  $(call AddDepends/ipt)\n\
endef\n\
\n\
define KernelPackage/ipt-socket/description\n\
  Kernel modules for socket matching\n\
endef\n\
\n\
$(eval $(call KernelPackage,ipt-socket))' package/kernel/linux/modules/netfilter.mk

# 添加 iptables-mod-socket 依赖
sed -i '382i\ \
define Package/iptables-mod-socket\n\
$(call Package/iptables/Module, +kmod-ipt-socket)\n\
  TITLE:=Socket match iptables extensions\n\
endef\n\
\n\
define Package/iptables-mod-socket/description\n\
Socket match iptables extensions.\n\
\n\
 Matches:\n\
  - socket\n\
\n\
endef' package/network/utils/iptables/Makefile

# 添加 kmod-nf-socket 依赖
sed -i '/$(eval \$(call KernelPackage,nft-queue))/a\
\
define KernelPackage/nft-socket\n\
  SUBMENU:=$(NF_MENU)\n\
  TITLE:=Netfilter nf_tables socket support\n\
  DEPENDS:=+kmod-nft-core +kmod-nf-socket\n\
  FILES:=$(foreach mod,$(NFT_SOCKET-m),$(LINUX_DIR)/net/$(mod).ko)\n\
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NFT_SOCKET-m)))\n\
  KCONFIG:=$(KCONFIG_NFT_SOCKET)\n\
endef\n\
\n\
$(eval $(call KernelPackage,nft-socket))\n\
\n\
define KernelPackage/nft-tproxy\n\
  SUBMENU:=$(NF_MENU)\n\
  TITLE:=Netfilter nf_tables tproxy support\n\
  DEPENDS:=+kmod-nft-core +kmod-nf-tproxy +kmod-nf-conntrack\n\
  FILES:=$(foreach mod,$(NFT_TPROXY-m),$(LINUX_DIR)/net/$(mod).ko)\n\
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NFT_TPROXY-m)))\n\
  KCONFIG:=$(KCONFIG_NFT_TPROXY)\n\
endef\n\
\n\
$(eval $(call KernelPackage,nft-tproxy))\n\
\n\
define KernelPackage/nft-compat\n\
  SUBMENU:=$(NF_MENU)\n\
  TITLE:=Netfilter nf_tables compat support\n\
  DEPENDS:=+kmod-nft-core +kmod-nf-ipt\n\
  FILES:=$(foreach mod,$(NFT_COMPAT-m),$(LINUX_DIR)/net/$(mod).ko)\n\
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NFT_COMPAT-m)))\n\
  KCONFIG:=$(KCONFIG_NFT_COMPAT)\n\
endef\n\
\n\
$(eval $(call KernelPackage,nft-compat))\n\
\n\
define KernelPackage/nft-xfrm\n\
  SUBMENU:=$(NF_MENU)\n\
  TITLE:=Netfilter nf_tables xfrm support (ipsec)\n\
  DEPENDS:=+kmod-nft-core\n\
  FILES:=$(foreach mod,$(NFT_XFRM-m),$(LINUX_DIR)/net/$(mod).ko)\n\
  AUTOLOAD:=$(call AutoProbe,$(notdir $(NFT_XFRM-m)))\n\
  KCONFIG:=$(KCONFIG_NFT_XFRM)\n\
endef\n\
\n\
$(eval $(call KernelPackage,nft-xfrm))' package/kernel/linux/modules/netfilter.mk

# nf-tproxy nf-socket
sed -i '/$(eval $(call KernelPackage,nf-flow))/a\
\
define KernelPackage/nf-socket\n  SUBMENU:=$(NF_MENU)\n  TITLE:=Netfilter socket lookup support\n  KCONFIG:= $(KCONFIG_NF_SOCKET)\n  FILES:=$(foreach mod,$(NF_SOCKET-m),$(LINUX_DIR)/net/$(mod).ko)\n  AUTOLOAD:=$(call AutoProbe,$(notdir $(NF_SOCKET-m)))\nendef\n\n$(eval $(call KernelPackage,nf-socket))\
\
define KernelPackage/nf-tproxy\n  SUBMENU:=$(NF_MENU)\n  TITLE:=Netfilter tproxy support\n  KCONFIG:= $(KCONFIG_NF_TPROXY)\n  FILES:=$(foreach mod,$(NF_TPROXY-m),$(LINUX_DIR)/net/$(mod).ko)\n  AUTOLOAD:=$(call AutoProbe,$(notdir $(NF_TPROXY-m)))\nendef\n\n$(eval $(call KernelPackage,nf-tproxy))' package/kernel/linux/modules/netfilter.mk

#sed -i '1isrc-git mosdns https://github.com/sbwml/luci-app-mosdns'  feeds.conf.default
#sed -i '3isrc-git helloworld https://github.com/sbwml/openwrt_helloworld' feeds.conf.default
# echo 'src-git helloworld https://github.com/fw876/helloworld' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall;luci-smartdns-dev' >>feeds.conf.default