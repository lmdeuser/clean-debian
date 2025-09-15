#!/bin/bash
# Clean Debian/Ubuntu system: remove old kernels, config files, trash, and clean APT cache
# Author: Dmitriy Volkov
# License: MIT
# GitHub: https://github.com/lmdeuser/clean-debian
# Colors for output
YELLOW="\033[1;33m"
RED="\033[0;31m"
ENDCOLOR="\033[0m"
# Check for root privileges
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: This script requires root privileges.${ENDCOLOR}"
    echo -e "${YELLOW}Run with: sudo $0${ENDCOLOR}"
    exit 1
fi
# Get current kernel version (strip -amd64, -cloud, -rt, -dbg suffixes)
CURKERNEL=$(uname -r | sed -e 's/-amd64$//' -e 's/-cloud$//' -e 's/-rt$//' -e 's/-dbg$//' | cut -d'-' -f1,2 | sed 's/-/\\-/g')
echo -e "${YELLOW}Current kernel: $(uname -r)${ENDCOLOR}"
# Patterns for kernel packages
LINUXPKG="linux-(image|headers|modules|tools|support)"
# Exclude common and current architecture/cloud kernels
METALINUXPKG="linux-(image|headers|modules)-(common|${ARCH:-amd64}|cloud|rt|tools|support)"
# Find old configuration files (packages in 'rc' state)
OLDCONF=$(dpkg -l | awk '/^rc/ {print $2}')
# Find old kernels: installed, not current, not common
OLDKERNELS=$(dpkg -l | awk '/^ii/ {print $2}' | \
    grep -E "$LINUXPKG" | \
    grep -vE "$METALINUXPKG" | \
    grep -v "$(uname -r | sed -e 's/-amd64//' -e 's/-cloud//')" | \
    sort -V | \
    head -n -1 2>/dev/null || true)
echo -e "${YELLOW}Cleaning APT cache...${ENDCOLOR}"
apt clean
if [ -n "$OLDCONF" ]; then
    echo -e "${YELLOW}Removing old configuration files...${ENDCOLOR}"
    apt purge -y $OLDCONF
else
    echo -e "${YELLOW}No old configuration files to remove.${ENDCOLOR}"
fi
if [ -n "$OLDKERNELS" ]; then
    echo -e "${YELLOW}Removing old kernels: $OLDKERNELS${ENDCOLOR}"
    apt purge -y $OLDKERNELS
else
    echo -e "${YELLOW}No old kernels to remove.${ENDCOLOR}"
fi
# Clean trash for all users
echo -e "${YELLOW}Cleaning trash for all users...${ENDCOLOR}"
for user_home in /home/* /root; do
    [ -d "$user_home" ] || continue
    trash_dir="$user_home/.local/share/Trash"
    if [ -d "$trash_dir" ]; then
        rm -rf "$trash_dir/files/"* "$trash_dir/info/"* 2>/dev/null || true
    fi
done
# Update package list (quiet mode)
echo -e "${YELLOW}Updating package list...${ENDCOLOR}"
apt update -qq > /dev/null 2>&1
echo -e "${YELLOW}Cleanup completed successfully.${ENDCOLOR}"