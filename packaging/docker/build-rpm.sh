#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
uid="$(id -u)"
gid="$(id -g)"
image="${EMEDITOR_WINE_RPM_DOCKER_IMAGE:-fedora:latest}"
pkgrel="${PKGREL:-1}"

restore_owner() {
  docker run --rm -v "${root}:/work" -w /work "${image}" \
    chown -R "${uid}:${gid}" build dist >/dev/null 2>&1 || true
}
trap restore_owner EXIT

docker run --rm -e "PKGREL=${pkgrel}" -v "${root}:/work" -w /work "${image}" bash -lc '
  dnf -y install rpm-build make curl ca-certificates p7zip p7zip-plugins
  make rpm
'
