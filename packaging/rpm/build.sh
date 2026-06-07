#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
pkgname="emeditor-wine"
pkgver="${EMEDITOR_WINE_VERSION:-26.1.1}"
topdir="${root}/build/rpm"
dist="${root}/dist"

if ! command -v rpmbuild >/dev/null 2>&1; then
  printf 'missing dependency: rpmbuild\n' >&2
  exit 1
fi

rm -rf "${topdir}"
mkdir -p "${topdir}/"{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS} "${dist}"

install -Dm755 "${root}/scripts/emeditor-wine" "${topdir}/SOURCES/emeditor-wine"
install -Dm644 "${root}/assets/emeditor-wine.desktop" "${topdir}/SOURCES/emeditor-wine.desktop"
install -Dm644 "${root}/README.md" "${topdir}/SOURCES/README.md"
install -Dm644 "${root}/LICENSE" "${topdir}/SOURCES/LICENSE"
"${root}/scripts/extract-emeditor-icon.sh" "${topdir}/SOURCES/emeditor-wine.png" "${root}/build/cache" >/dev/null

install -Dm644 "${root}/packaging/rpm/emeditor-wine.spec" "${topdir}/SPECS/emeditor-wine.spec"
rpmbuild --define "_topdir ${topdir}" --define "emeditor_version ${pkgver}" -bb "${topdir}/SPECS/emeditor-wine.spec"
find "${topdir}/RPMS" -type f -name '*.rpm' -exec install -Dm644 '{}' "${dist}/" ';'
