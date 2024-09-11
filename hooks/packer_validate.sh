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
      args+=("$1")
      shift
      ;;
    *)
      files+=("$1")
      shift
      ;;
  esac
done

paths=()
index=0
for file in "${files[@]}"; do
  paths[index]=$(dirname "$file")
  ((++index))
done

unique_paths=()
while IFS='' read -r line; do unique_paths+=("$line"); done < <(printf '%s\n' "${paths[@]}" | sort --unique)

error=0

for path in "${unique_paths[@]}"; do
  if ! packer validate "${args[@]}" "$path"; then
    error=1
    echo
    echo "Failed path: $path"
    echo "================================"
  fi
done

if [[ $error -ne 0 ]]; then
  exit 1
fi
