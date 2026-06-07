#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
out="${1:-${root}/build/aur-source}"

if ! command -v makepkg >/dev/null 2>&1; then
  printf 'missing dependency: makepkg\n' >&2
  exit 1
fi

rm -rf "${out}"
mkdir -p "${out}"
install -Dm644 "${root}/packaging/arch/PKGBUILD" "${out}/PKGBUILD"

(
  cd "${out}"
  checksums="$(makepkg -g)"
  tmp="$(mktemp)"

  awk -v checksums="${checksums}" '
    /^sha256sums=\(/ {
      print checksums
      in_sums = 1
      next
    }
    in_sums && /^\)/ {
      in_sums = 0
      next
    }
    !in_sums {
      print
    }
  ' PKGBUILD >"${tmp}"

  mv -f "${tmp}" PKGBUILD
  makepkg --printsrcinfo > .SRCINFO
)

printf '%s\n' "${out}"
