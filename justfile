build-oci-os-base-tarball:
    podman build . \
        --arch=arm64 \
        --tag=ghcr.io/vially/archlinuxarm/base:tarball \
        --file=./os/tarball/Dockerfile

build-oci-os-base:
    podman build . \
        --arch=arm64 \
        --tag=ghcr.io/vially/archlinuxarm/base:latest \
        --file=./os/base/Dockerfile

build-pkg-uboot-radxa-zero-3:
    podman build ./packages/uboot-radxa-zero-3 \
        --arch=arm64 \
        --tag=ghcr.io/vially/archlinuxarm/pkg/uboot-radxa-zero-3:latest \
        --file=./packages/Dockerfile
