#!/usr/bin/env bash
#
# Script Name: install.sh
# Version : 1.0
# Description: Auto Customization GNOME 48 Look Like macOS
# Supports: openSUSE Tumbleweed, Manjaro Linux KDE, Fedora, Debian
# Author: linuxscoop
# Created: July 14, 2025
# Last Modified: November 19, 2025
#

detect_distro() {
    DISTRO="unknown"
    DISTRO_VERSION="unknown"
    DISTRO_FULL="unknown"

    if [[ ! -f /etc/os-release ]]; then
        print_error "/etc/os-release not found"
        return 1
    fi

    # shellcheck source=/dev/null
    source /etc/os-release

    VERSION_ID="${VERSION_ID:-unknown}"

    case "$ID" in
        fedora)
            DISTRO="fedora"
            DISTRO_VERSION="$VERSION_ID"
            DISTRO_FULL="Fedora $VERSION_ID"
            ;;
        ubuntu)
            # Check if it's Kubuntu
            if [[ "${NAME,,}" == *"kubuntu"* ]] || [[ -n "${UBUNTU_CODENAME}" && -f /usr/share/plasma/plasmoids ]]; then
                DISTRO="kubuntu"
                DISTRO_VERSION="$VERSION_ID"
                DISTRO_FULL="Kubuntu $VERSION_ID"
            else
                DISTRO="ubuntu"
                DISTRO_VERSION="$VERSION_ID"
                DISTRO_FULL="Ubuntu $VERSION_ID"
            fi
            ;;
        neon|kde-neon)
            DISTRO="kdeneon"
            DISTRO_VERSION="${UBUNTU_CODENAME:-$VERSION_ID}"
            DISTRO_FULL="KDE neon (based on Ubuntu ${UBUNTU_CODENAME:-$VERSION_ID})"
            ;;
        debian)
            if [[ -n "${DEBIAN_VERSION_FULL}" ]]; then
                DISTRO="mxlinux"
                DISTRO_VERSION="$VERSION_ID"
                DISTRO_FULL="MX Linux $VERSION_ID"
            else
                DISTRO="debian"
                DISTRO_VERSION="$VERSION_ID"
                DISTRO_FULL="Debian $VERSION_ID"
            fi
            ;;
        mx)
            DISTRO="mxlinux"
            DISTRO_VERSION="$VERSION_ID"
            DISTRO_FULL="MX Linux $VERSION_ID"
            ;;
        manjaro)
            DISTRO="manjaro"
            DISTRO_VERSION="${VERSION_ID:-rolling}"
            DISTRO_FULL="Manjaro Linux"
            ;;
        arch)
            DISTRO="arch"
            DISTRO_VERSION="rolling"
            DISTRO_FULL="Arch Linux"
            ;;
        opensuse*|suse)
            DISTRO="opensuse"
            if [[ "$ID" == "opensuse-tumbleweed" ]] || [[ "$NAME" == *"Tumbleweed"* ]]; then
                DISTRO_VERSION="tumbleweed"
                DISTRO_FULL="openSUSE Tumbleweed"
            else
                DISTRO_VERSION="$VERSION_ID"
                DISTRO_FULL="openSUSE $VERSION_ID"
            fi
            ;;
        *)
            DISTRO="unknown"
            DISTRO_VERSION="unknown"
            DISTRO_FULL="Unknown Distribution"
            ;;
    esac

    echo "Detected: $DISTRO_FULL" >> "${LOGFILE:-/dev/null}"
    export DISTRO DISTRO_VERSION DISTRO_FULL
    return 0
}
