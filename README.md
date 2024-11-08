### ArchLinuxARM image builder

#### Building the `archlinuxarm` image locally

```sh
podman build \
    --arch=arm64 \
    --tag=ghcr.io/vially/archlinuxarm \
    --fle=./archlinuxarm.Dockerfile
```

#### Building the `archlinuxarm:tarball-latest` image locally

```sh
podman build \
    --arch=arm64 \
    --tag=ghcr.io/vially/archlinuxarm:tarball-latest \
    --file=./tarball.Dockerfile
```
