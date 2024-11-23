FROM ghcr.io/vially/archlinuxarm/base:tarball-20230301

LABEL org.opencontainers.image.source=https://github.com/vially/archlinuxarm
LABEL org.opencontainers.image.description="Arch Linux ARM: base OS"
LABEL org.opencontainers.image.licenses=MIT

# Various quirks are required due to packaging changes between the versions in
# the tarball release and the latest versions.
#
# Note: These quirks need to continuously be kept up-to-date with latest changes
# and whenever a new Arch Linux ARM tarball version gets released.

### Pre-install quirks ###
RUN rm /etc/passwd

### Update all packages ###
RUN pacman -Syu --noconfirm

### Post-install quirks ###
RUN echo 'alarm:x:1000:1000::/home/alarm:/bin/bash' >> /etc/passwd

### Validation ###
RUN --mount=target=/mnt /mnt/os/base/scripts/validation.sh
