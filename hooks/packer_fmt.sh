#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

if [ -z "$(command -v packer)" ]; then
  echo "packer is required"
  exit 1
fi

args=()
files=()

while (("$#")); do
  case "$1" in
    -*)
      if [ -f "$1" ]; then
        files+=("$1")
      else
        args+=("$1")
      fi
      shift
      ;;
    *)
      files+=("$1")
      shift
      ;;
  esac
done

error=0

for file in "${files[@]}"; do
  if ! packer fmt "${args[@]}" -- "$file"; then
    error=1
    echo
    echo "Failed path: $file"
    echo "================================"
  fi
done

if [[ $error -ne 0 ]]; then
  exit 1
fi
