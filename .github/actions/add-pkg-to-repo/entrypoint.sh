#!/usr/bin/bash

set -euo pipefail

main() {
    maybe_configure_rclone
    add_pkg_to_repo "$@"
}

maybe_configure_rclone() {
    if [[ ! -f "$HOME/.config/rclone/rclone.conf" && -n "$RCLONE_CONFIG_SECRET" ]]; then
        mkdir -p ~/.config/rclone
        echo "$RCLONE_CONFIG_SECRET" > ~/.config/rclone/rclone.conf
    fi
}

generate_sync_file_names() {
    local repo="$1"
    local pkg="$(basename "$2")"

    cat > /tmp/repo-db-files.txt <<EOL
${repo}.db
${repo}.db.tar.zst
${repo}.db.tar.zst.old
${repo}.files
${repo}.files.tar.zst
${repo}.files.tar.zst.old
${pkg}
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

    # TODO: Acquire some kind of lock to avoid possible race conditions between
    # multiple instances of this action running in parallel.
    rclone copy --files-from "$filenames_to_sync" "$bucket" "$local_repo_path"
    cp "$pkg" "$local_repo_path"
    repo-add "${local_repo_path}/${repo}.db.tar.zst" "$pkg"
    rclone copy --files-from "$filenames_to_sync" --copy-links "$local_repo_path" "$bucket"
    # TODO: Release lock
}

main "$@"
