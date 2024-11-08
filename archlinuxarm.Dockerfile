FROM ghcr.io/vially/archlinuxarm:tarball-20230301

# Various quirks are required due to packaging changes between the versions in
# the tarball release and the latest versions.
#
# Note: These quirks need to continuously be kept up-to-date with latest changes
# and whenever a new ArchLinuxARM tarball version gets released.

### Pre-install quirks ###
RUN rm /etc/passwd

### Update all packages ###
RUN pacman -Syu --noconfirm

### Post-install quirks ###
RUN echo 'alarm:x:1000:1000::/home/alarm:/bin/bash' >> /etc/passwd

### Validation ###
RUN --mount=target=/mnt /mnt/scripts/validation.sh
