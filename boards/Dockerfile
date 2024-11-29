FROM ghcr.io/vially/archlinuxarm/base:latest

COPY ./boards/sysroot/ /

RUN <<EOF
cat <<'CFG' >> /etc/pacman.conf

[vially]
SigLevel = PackageOptional
Server = https://repo.vially.dev/archlinux/$arch
CFG

pacman -Syy
EOF
