#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

if [ -z "$(command -v packer)" ]; then
  echo "packer is required"
  exit 1
fi

error=0

for file in "$@"; do
  if ! packer fmt -check "$file"; then
    packer fmt -write "$file"
    error=1
    echo
    echo "Failed path: $file"
    echo "================================"
  fi
done

if [[ $error -ne 0 ]]; then
  exit 1
fi
