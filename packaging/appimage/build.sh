#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
pkgname="emeditor-wine"
pkgver="${EMEDITOR_WINE_VERSION:-26.1.1}"
pkgrel="${PKGREL:-1}"
appdir="${root}/build/appimage/EmEditor-Wine.AppDir"
dist="${root}/dist"
appimagetool="${APPIMAGETOOL:-appimagetool}"

if ! command -v "${appimagetool}" >/dev/null 2>&1; then
  printf 'missing dependency: appimagetool\n' >&2
  exit 1
fi

rm -rf "${appdir}"
mkdir -p "${appdir}" "${dist}"

install -Dm755 "${root}/scripts/emeditor-wine" "${appdir}/usr/bin/emeditor-wine"
install -Dm755 "${root}/packaging/appimage/AppRun" "${appdir}/AppRun"
sed 's|^Exec=.*|Exec=AppRun %F|' "${root}/assets/emeditor-wine.desktop" >"${appdir}/emeditor-wine.desktop"
install -Dm644 "${appdir}/emeditor-wine.desktop" "${appdir}/usr/share/applications/emeditor-wine.desktop"
"${root}/scripts/extract-emeditor-icon.sh" "${appdir}/emeditor-wine.png" "${root}/build/cache" >/dev/null
install -Dm644 "${appdir}/emeditor-wine.png" "${appdir}/usr/share/icons/hicolor/256x256/apps/emeditor-wine.png"

ARCH="${ARCH:-x86_64}" "${appimagetool}" "${appdir}" "${dist}/EmEditor-Wine-${pkgver}-${pkgrel}-${ARCH:-x86_64}.AppImage"
