#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
uid="$(id -u)"
gid="$(id -g)"
image="${EMEDITOR_WINE_APPIMAGE_DOCKER_IMAGE:-ubuntu:24.04}"
appimagetool_url="${APPIMAGETOOL_URL:-https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage}"

restore_owner() {
  docker run --rm -v "${root}:/work" -w /work "${image}" \
    chown -R "${uid}:${gid}" build dist >/dev/null 2>&1 || true
}
trap restore_owner EXIT

docker run --rm -v "${root}:/work" -w /work "${image}" bash -lc "
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl make p7zip-full file
  curl -fL --retry 3 -o /tmp/appimagetool '${appimagetool_url}'
  chmod +x /tmp/appimagetool
  APPIMAGE_EXTRACT_AND_RUN=1 APPIMAGETOOL=/tmp/appimagetool make appimage
"
