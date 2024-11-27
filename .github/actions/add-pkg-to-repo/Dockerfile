FROM archlinux:latest

COPY entrypoint.sh /entrypoint.sh

RUN <<EOF
pacman -Syu --noconfirm
pacman -S rclone --noconfirm
EOF

ENTRYPOINT ["/entrypoint.sh"]
