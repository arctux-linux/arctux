build-oci-os-base-tarball:
    podman build . \
        --arch=arm64 \
        --tag=ghcr.io/arctux-linux/arctux/base:tarball \
        --file=./os/tarball/Dockerfile

build-oci-os-base:
    podman build . \
        --arch=arm64 \
        --tag=ghcr.io/arctux-linux/arctux/base:latest \
        --file=./os/base/Dockerfile

build-pkg-uboot-radxa-zero-3:
    podman build ./packages/uboot-radxa-zero-3 \
        --arch=arm64 \
        --tag=ghcr.io/arctux-linux/arctux/pkg/uboot-radxa-zero-3:latest \
        --output=type=local,dest=./packages/uboot-radxa-zero-3 \
        --file=./packages/Dockerfile

build-pkg-uboot-cm3588-nas:
    podman build ./packages/uboot-cm3588-nas \
        --arch=arm64 \
        --tag=ghcr.io/arctux-linux/arctux/pkg/uboot-cm3588-nas:latest \
        --output=type=local,dest=./packages/uboot-cm3588-nas \
        --file=./packages/Dockerfile
