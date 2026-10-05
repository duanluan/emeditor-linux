#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
uid="$(id -u)"
gid="$(id -g)"
image="${EMEDITOR_WINE_DEB_DOCKER_IMAGE:-debian:stable-slim}"
pkgrel="${PKGREL:-1}"

restore_owner() {
  docker run --rm -v "${root}:/work" -w /work "${image}" \
    chown -R "${uid}:${gid}" build dist >/dev/null 2>&1 || true
}
trap restore_owner EXIT

docker run --rm -e "PKGREL=${pkgrel}" -v "${root}:/work" -w /work "${image}" bash -lc '
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y dpkg make curl ca-certificates p7zip-full
  make deb
'
