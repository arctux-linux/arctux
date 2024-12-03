#!/usr/bin/bash

set -euo pipefail

main() {
    maybe_configure_rclone
    add_pkg_to_repo "$@"
}

maybe_configure_rclone() {
    if [[ ! -f "$HOME/.config/rclone/rclone.conf" && -n "$RCLONE_CONFIG_SECRET" ]]; then
        mkdir -p ~/.config/rclone
        echo "$RCLONE_CONFIG_SECRET" >~/.config/rclone/rclone.conf
    fi
}

generate_sync_file_names() {
    local repo="$1"
    local pkg
    pkg="$(basename "$2")"

    cat >/tmp/repo-db-files.txt <<EOL
${repo}.db
${repo}.db.sig
${repo}.db.tar.zst
${repo}.db.tar.zst.sig
${repo}.db.tar.zst.old
${repo}.db.tar.zst.old.sig
${repo}.files
${repo}.files.sig
${repo}.files.tar.zst
${repo}.files.tar.zst.sig
${repo}.files.tar.zst.old
${repo}.files.tar.zst.old.sig
${pkg}
${pkg}.sig
EOL

    echo /tmp/repo-db-files.txt
}

add_pkg_to_repo() {
    local repo="$1"
    local pkg="$2"
    local bucket="$3"

    local filenames_to_sync
    filenames_to_sync="$(generate_sync_file_names "$repo" "$pkg")"

    local local_repo_path="/tmp/repository"
    mkdir "$local_repo_path"

    # Sign package
    echo -n "$GPG_SIGNING_KEY" | gpg --batch --import
    gpg --batch --detach-sign --output "${pkg}.sig" --sign "${pkg}"

    # TODO: Acquire some kind of lock to avoid possible race conditions between
    # multiple instances of this action running in parallel.
    rclone copy --files-from "$filenames_to_sync" "$bucket" "$local_repo_path"
    cp "$pkg" "$pkg.sig" "$local_repo_path"
    repo-add --verify --sign "${local_repo_path}/${repo}.db.tar.zst" "$pkg"
    rclone copy --files-from "$filenames_to_sync" --copy-links "$local_repo_path" "$bucket"
    # TODO: Release lock
}

main "$@"
