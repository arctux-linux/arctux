FROM ghcr.io/vially/archlinuxarm/base:devel AS build

COPY <<EOF /etc/makepkg.conf.d/custom-makepkg.conf
PKGDEST="/pkg"
BUILDDIR="/builddir"
SRCDEST="/builddir"
SRCPKGDEST="/builddir"
# Disable falling back to `sudo`
PACMAN_AUTH=("bash" "-c" "%c")
EOF

RUN --mount=rw,target=/buildctx <<EOF
# Monkey patch `makepkg` to allow building as `root`. This is required because
# `sudo` is not working properly in a `RUN` instruction when executed by
# `podman` through `binfmt_misc`: https://stackoverflow.com/a/77354286
sed -i 's/error "$(gettext "Running %s as root/warning "$(gettext "Running %s as root/' /usr/bin/makepkg
sed -i '/exit $E_ROOT/d' /usr/bin/makepkg

makepkg --dir=/buildctx --syncdeps --noconfirm

# (Optional) Copy the package to the build context directory to make it easily
# available on the host
cp $(makepkg --dir=/buildctx --packagelist) /buildctx
EOF


FROM scratch
COPY --from=build /pkg /
