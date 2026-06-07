#!/usr/bin/env bash
set -euo pipefail

pkgver="${EMEDITOR_WINE_VERSION:-26.1.1}"
msi_name="emed64_${pkgver}.msi"
msi_url="${EMEDITOR_WINE_MSI_URL:-https://download.emeditor.com/${msi_name}}"
msi_sha256="${EMEDITOR_WINE_MSI_SHA256:-bc54ae3700a657c159f176b8f5ad646a4cfef3090d8097ff8dfa99067340f5b5}"
cache_dir="${1:-build/cache}"
msi_path="${cache_dir}/${msi_name}"

download_file() {
  local url="$1"
  local output="$2"

  if command -v curl >/dev/null 2>&1; then
    curl -fL --retry 3 --output "${output}" "${url}"
  elif command -v wget >/dev/null 2>&1; then
    wget -O "${output}" "${url}"
  else
    printf 'missing dependency: curl or wget\n' >&2
    return 1
  fi
}

mkdir -p "${cache_dir}"

if [[ ! -f "${msi_path}" ]]; then
  tmp="${msi_path}.part"
  rm -f "${tmp}"
  download_file "${msi_url}" "${tmp}"
  mv -f "${tmp}" "${msi_path}"
fi

actual="$(sha256sum "${msi_path}" | awk '{print $1}')"
if [[ "${actual}" != "${msi_sha256}" ]]; then
  printf 'checksum mismatch: %s\nexpected: %s\nactual:   %s\n' "${msi_path}" "${msi_sha256}" "${actual}" >&2
  exit 1
fi

printf '%s\n' "${msi_path}"

