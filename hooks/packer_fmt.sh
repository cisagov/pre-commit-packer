#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

if [ -z "$(command -v packer)" ]; then
  echo "packer is required"
  exit 1
fi

error=0

options=""
files=()
packer_cmd=""
for arg in "$@"; do
  # Filtering out packer options from packer files
  # based on if they start with a "-" or not.
  # We are assuming that files will not begin with a "-".
  if [[ $arg == -* ]]; then
    options+="$arg "
  else
    files+=("$arg")
  fi
done

# Remove the trailing space
options="${options%' '}"

if [[ -z $options ]]; then
  packer_cmd="packer fmt -check"
else
  packer_cmd="packer fmt $options"
fi

for file in "${files[@]}"; do
  if ! $packer_cmd "$file"; then
    error=1
    echo
    echo "Failed path: $file"
    echo "================================"
  fi
done

if [[ $error -ne 0 ]]; then
  exit 1
fi
