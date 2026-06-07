#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
pkgname="emeditor-wine"
pkgver="${EMEDITOR_WINE_VERSION:-26.1.1}"
pkgrel="${PKGREL:-1}"
arch="${DEB_ARCH:-amd64}"
dist="${root}/dist"
work="${root}/build/deb/${pkgname}_${pkgver}-${pkgrel}_${arch}"

rm -rf "${work}"
mkdir -p "${work}/DEBIAN" "${dist}"

install -Dm755 "${root}/scripts/emeditor-wine" "${work}/usr/bin/emeditor-wine"
install -Dm644 "${root}/assets/emeditor-wine.desktop" "${work}/usr/share/applications/emeditor-wine.desktop"
install -Dm644 "${root}/README.md" "${work}/usr/share/doc/${pkgname}/README.md"
install -Dm644 "${root}/LICENSE" "${work}/usr/share/doc/${pkgname}/copyright"
"${root}/scripts/extract-emeditor-icon.sh" "${work}/usr/share/icons/hicolor/256x256/apps/emeditor-wine.png" "${root}/build/cache" >/dev/null

cat >"${work}/DEBIAN/control" <<EOF
Package: ${pkgname}
Version: ${pkgver}-${pkgrel}
Section: editors
Priority: optional
Architecture: ${arch}
Maintainer: duanluan <duanluan@outlook.com>
Depends: bash, wine | wine64, curl | wget, ca-certificates, fonts-noto-cjk, x11-xserver-utils, hicolor-icon-theme
Recommends: desktop-file-utils
Homepage: https://www.emeditor.com/
Description: EmEditor launcher for Wine
 Unofficial Linux launcher for running EmEditor through a dedicated Wine prefix.
 The EmEditor MSI is downloaded from the official source on first run.
EOF

dpkg-deb --build --root-owner-group "${work}" "${dist}/${pkgname}_${pkgver}-${pkgrel}_${arch}.deb"
