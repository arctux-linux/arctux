FROM scratch

LABEL org.opencontainers.image.source=https://github.com/vially/archlinuxarm
LABEL org.opencontainers.image.description="Arch Linux ARM: base OS (from tarball release)"
LABEL org.opencontainers.image.licenses=MIT

# This needs to be manually downloaded into the build context directory in
# advance because archives from remote URLs are not automatically extracted:
# https://docs.docker.com/reference/dockerfile/#adding-local-tar-archives
ADD ./ArchLinuxARM-aarch64-latest.tar.gz /

RUN pacman-key --init && pacman-key --populate archlinuxarm
