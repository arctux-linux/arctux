FROM scratch

# This needs to be manually downloaded into the build context directory in
# advance because archives from remote URLs are not automatically extracted:
# https://docs.docker.com/reference/dockerfile/#adding-local-tar-archives
ADD ./ArchLinuxARM-aarch64-latest.tar.gz /

RUN pacman-key --init && pacman-key --populate archlinuxarm
