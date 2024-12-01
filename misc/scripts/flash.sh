#!/usr/bin/bash

set -euo pipefail

generate_dockerfile() {
    local board="$1"
    local packages

    packages="$(yq '.packages | join(" ")' "./boards/${board}.yaml")"
    cp "./boards/Dockerfile" "./boards/Dockerfile.${board}"
    echo "RUN pacman -S --noconfirm ${packages}" >>"./boards/Dockerfile.${board}"
}

create_rootfs() {
    local board="$1"
    local output_dest="$2"
    local dockerfile="Dockerfile.${board}"

    generate_dockerfile "$board"

    # Sometimes the tar archive is incomplete unless the cache is disabled.
    # TODO: Investigate root cause and remove the `--no-cache` flag.
    podman build . \
        --arch=arm64 \
        --no-cache \
        --tag="ghcr.io/vially/archlinuxarm/board/${board}:latest" \
        --output="type=tar,dest=${output_dest}" \
        --file="./boards/${dockerfile}"
}

create_image() {
    local board="$1"
    local chroot_dir="./out/chroot"
    local rootfs_tar="./out/rootfs-${board}.tar"
    local board_img="./out/ArchLinuxARM-${board}.img"
    local board_yaml="./boards/${board}.yaml"

    rm "$board_img" || true
    rmdir "$chroot_dir" || true

    if [[ ! -f "$rootfs_tar" ]]; then
        create_rootfs "$board" "$rootfs_tar"
    fi

    root_part_index="$(yq '.partitions[] | select(.name == "rootfs") | path | (.[-1] + 1)' "$board_yaml")"
    echo "Root partition index: $root_part_index"

    truncate -s 3g "$board_img"
    partitions="$(yq '.partitions[] | to_entries | map(.key + "=" + .value) | join(" ")' "$board_yaml")"
    echo -e "label: gpt\nfirst-lba: 34\n${partitions}" | sfdisk "$board_img"

    # Setup root filesystem
    loop_device=$(sudo losetup --partscan --show --find "$board_img")
    loop_partition="${loop_device}p${root_part_index}"
    sudo mkfs.ext4 "$loop_partition"
    sudo mkdir "$chroot_dir"
    sudo mount "$loop_partition" "$chroot_dir"
    sudo tar -xpf "$rootfs_tar" --directory "$chroot_dir"

    bootloader_type="$(yq .bootloader.type "./$board_yaml")"
    if [[ "uboot-rockchip" == "$bootloader_type" ]]; then
        # Install U-Boot bootloader at required offsets:
        # https://opensource.rock-chips.com/wiki_Boot_option
        dd if="$chroot_dir/boot/idbloader.img" of="$board_img" seek=64 conv=notrunc
        dd if="$chroot_dir/boot/u-boot.itb" of="$board_img" seek=16384 conv=notrunc
    else
        echo "Unsupported bootloader type: $bootloader_type. Only U-Boot Rockchip bootloader is supported right now."
        exit 1
    fi

    sudo umount "$chroot_dir"
    sudo rmdir "$chroot_dir"
    sudo losetup --detach "$loop_device"
}

flash_image() {
    local board="$1"
    local loader_img="./out/MiniLoaderAll.bin"
    local board_img="./out/ArchLinuxARM-${board}.img"

    if ! rkdeveloptool ld >>/dev/null; then
        echo "Unable to find any device in Maskrom mode. Please connect the device in Maskrom mode and retry."
        exit 1
    fi

    sudo rkdeveloptool db "${loader_img}"
    sudo rkdeveloptool wl 0 "${board_img}"
    sudo rkdeveloptool rd
}

main() {
    local board="$1"

    if [[ ! -f "./out/ArchLinuxARM-${board}.img" ]]; then
        create_image "$board"
    fi

    flash_image "$board"
}

main "$@"
