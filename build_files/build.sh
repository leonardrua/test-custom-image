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
dnf5 -y copr enable bieszczaders/kernel-cachyos
dnf5 -y config-manager addrepo --from-repofile=https://repo.vivaldi.com/archive/vivaldi-fedora.repo

dnf5 -y install kernel-cachyos kernel-cachyos-devel-matched

for pkg in kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra; do
    rpm --erase $pkg --nodeps
done

mkdir -p "/var/opt" && ln -s "/var/opt" "/opt"
dnf5 -y install vivaldi-stable
mkdir -p "/usr/lib/opt/vivaldi" && ln -s "../../usr/lib/opt/vivaldi" "/var/opt/vivaldi"
dnf5 -y install waydroid-helper
dnf5 -y install ananicy-cpp
dnf5 -y install cachyos-ksm-settings
dnf5 -y install cachyos-settings --allowerasing
# Disable COPRs so they don't end up enabled on the final image:
dnf5 -y copr disable cuteneko/waydroid-helper
dnf5 -y copr disable bieszczaders/kernel-cachyos-addons

KERNEL="$(rpm -qa | grep -P 'kernel-(|'"cachyos"'-)(\d+\.\d+\.\d+)' | sed -E 's/kernel-(|'"cachyos"'-)//')"
/usr/bin/dracut --no-hostonly --kver "$KERNEL" --reproducible -v --add ostree -f "/lib/modules/$KERNEL/initramfs.img"
chmod 0600 "/lib/modules/$KERNEL/initramfs.img"

alternatives --set fakeroot /usr/bin/fakeroot-sysv
