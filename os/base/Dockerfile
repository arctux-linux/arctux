FROM ghcr.io/arctux-linux/arctux/base:tarball-20230301

LABEL org.opencontainers.image.source=https://github.com/arctux-linux/arctux
LABEL org.opencontainers.image.description="Arctux Linux: base OS"
LABEL org.opencontainers.image.licenses=MIT

COPY ./os/base/sysroot/ /

RUN <<EOF
# Various quirks are required due to packaging changes between the versions in
# the tarball release and the latest versions.
#
# Note: These quirks need to continuously be kept up-to-date with latest changes
# and whenever a new Arch Linux ARM tarball version gets released.

### Pre-install quirks ###
rm /etc/passwd

# Configure arctux keyring
pacman-key --recv-keys makepkg@arctux.org
pacman-key --lsign-key makepkg@arctux.org
pacman -Syy
pacman -S --noconfirm arctux-keyring

### Update all packages ###
pacman -Syu --noconfirm

### Post-install quirks ###
rm /etc/pacman.conf.pacnew
echo 'alarm:x:1000:1000::/home/alarm:/bin/bash' >>/etc/passwd
EOF

### Validation ###
RUN --mount=target=/mnt /mnt/os/base/scripts/validation.sh
