#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
dnf5 install -y waydroid 

# Use a COPR Example:
#
dnf5 -y copr enable cuteneko/waydroid-helper
dnf5 -y copr enable bieszczaders/kernel-cachyos-addons
dnf5 -y install waydroid-helper
dnf5 -y install ananicy-cpp
# Disable COPRs so they don't end up enabled on the final image:
dnf5 -y copr disable cuteneko/waydroid-helper
dnf5 -y copr disable bieszczaders/kernel-cachyos-addons

#### Example for enabling a System Unit File

#systemctl enable podman.socket
alternatives --set fakeroot /usr/bin/fakeroot-sysv
