#!/bin/bash
# Get Package Versions
adguardhome_version=$(grep -oP 'PKG_VERSION:=\K[^ ]+' $(find feeds/ -name Makefile | grep adguardhome | head -n 1))
mosdns_version=$(grep -oP 'PKG_VERSION:=\K[^ ]+' $(find feeds/ -name Makefile | grep mosdns | head -n 1))
smartdns_version=$(grep -oP 'PKG_VERSION:=\K[^ ]+' feeds/kenzo/luci-app-smartdns/Makefile)
passwall_version=$(grep -oP 'PKG_VERSION:=\K[^ ]+' feeds/small/luci-app-passwall/Makefile)
passwall2_version=$(grep -oP 'PKG_VERSION:=\K[^ ]+' feeds/small/luci-app-passwall2/Makefile)
store_version=$(grep -oP 'PKG_VERSION:=\K[^ ]+' feeds/kenzo/luci-app-store/Makefile)
echo "adguardhome=$adguardhome_version" >> $GITHUB_ENV
echo "mosdns=$mosdns_version" >> $GITHUB_ENV
echo "smartdns=$smartdns_version" >> $GITHUB_ENV
echo "passwall_version=$passwall_version" >> $GITHUB_ENV
echo "passwall2_version=$passwall2_version" >> $GITHUB_ENV
echo "store=$store_version" >> $GITHUB_ENV
