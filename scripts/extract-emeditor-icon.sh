#!/usr/bin/env bash
set -euo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
output="${1:-${root}/build/emeditor-wine.png}"
cache_dir="${2:-${root}/build/cache}"

if ! command -v 7z >/dev/null 2>&1; then
  printf 'missing dependency: 7z\n' >&2
  exit 1
fi

msi_path="$("${root}/scripts/fetch-emeditor-msi.sh" "${cache_dir}")"
tmpdir="$(mktemp -d)"
trap 'rm -rf "${tmpdir}"' EXIT

7z e -y "${msi_path}" 'Binary.emeditor.targetsize256.png' -o"${tmpdir}" >/dev/null
install -Dm644 "${tmpdir}/Binary.emeditor.targetsize256.png" "${output}"
printf '%s\n' "${output}"

