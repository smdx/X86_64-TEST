#!/bin/bash
# Package Versions Output

echo "开始执行固件信息输出操作......"
echo "========================="

if [[ $REPO_URL == *"lede"* ]]; then
    # 如果地址包含"lede"，执行以下操作
    echo "Openwrt Lean-x86" >> release.txt
    echo "管理地址：10.0.0.1" >> release.txt
    echo "默认密码：空" >> release.txt
    echo "插件清单：AdGuard Home、MosDNS、SmartDNS、Passwall、Passwall2、OpenClash、Store、Vlmcsd、Qos-Sqm、Wol、natmap、udpxy、UPnP" >> release.txt
    echo "---------------------------------------------" >> release.txt
    echo "Adguardhome Version: $adguardhome" >> release.txt
    echo "MosDNS Version: $mosdns" >> release.txt
    echo "SmartDNS Version: $smartdns" >> release.txt
    echo "Passwall Version: $passwall_version" >> release.txt
    echo "Passwall2 Version: $passwall2_version" >> release.txt
    echo "OpenClash Version: $openclash" >> release.txt
    echo "Store Version: $store" >> release.txt
elif [[ $REPO_URL == *"immortalwrt"* ]]; then
    # 如果地址包含"immortalwrt"，执行以下操作
    echo "ImmortalWrt-x86" >> release.txt
    echo "管理地址：10.0.0.1" >> release.txt
    echo "默认密码：空" >> release.txt
    echo "插件清单：AdGuard Home、MosDNS、SmartDNS、Passwall、Passwall2、Store、Qos-Sqm、Wol、MultiSD_Lite、udpxy、Xupnpd、UPnP" >> release.txt
    echo "---------------------------------------------" >> release.txt
    echo "Adguardhome Version: $adguardhome" >> release.txt
    echo "MosDNS Version: $mosdns" >> release.txt
    echo "SmartDNS Version: $smartdns" >> release.txt
    echo "Passwall Version: $passwall_version" >> release.txt
    echo "Passwall2 Version: $passwall2_version" >> release.txt
    echo "Store Version: $store" >> release.txt
fi

echo "========================="
echo " 固件信息输出操作完成……"