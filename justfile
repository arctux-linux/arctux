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
