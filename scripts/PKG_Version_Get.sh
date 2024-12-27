#!/bin/bash

# 定义插件列表
plugins=(
    "adguardhome"
    "mosdns"
    "smartdns"
    "luci-app-passwall"
    "luci-app-passwall2"
    "luci-app-mihomo"
    "luci-app-openclash"
    "luci-app-store"
)

# 遍历插件
for plugin in "${plugins[@]}"; do
    # 查找插件目录
    dir=$(find package feeds -maxdepth 3 -type d -name "$plugin" -print -quit)

    # 检查找到的目录是否存在
    if [[ -z "$dir" ]]; then
        echo "未找到插件目录: $plugin"
        continue
    fi

    # 首先检查当前找到的目录下是否存在 Makefile
    makefile="$dir/Makefile"

    if [[ -f "$makefile" ]]; then
        echo "找到插件目录: $dir"  # 输出插件目录
    else
        # 如果当前目录下没有，尝试下一级同名目录
        makefile="$dir/$plugin/Makefile"
        if [[ -f "$makefile" ]]; then
            echo "找到插件目录: $dir/$plugin"  # 输出下一级插件目录
        else
            echo "未找到 Makefile: $plugin"
            continue
        fi
    fi

    # 读取版本信息
    version=$(grep -oP 'PKG_VERSION:=\K[^ ]+' "$makefile")

    # 尝试读取 PKG_RELEASE，如果不存在则赋值为空
    release=$(grep -oP 'PKG_RELEASE:=\K[^ ]+' "$makefile" || true)

    # 去除前缀 'luci-app-' 如果存在
    clean_name=${plugin/luci-app-/}

    # 确保版本信息格式正确
    if [[ -z "$version" ]]; then
        echo "未找到版本信息: $plugin"
        continue
    fi

    # 输出版本信息到 GITHUB_ENV
    if [[ -n "$release" ]]; then
        echo "${clean_name}=${version}-${release}" >> $GITHUB_ENV
    else
        echo "${clean_name}=${version}" >> $GITHUB_ENV # 如果没有 PKG_RELEASE，则只输出版本
    fi
done