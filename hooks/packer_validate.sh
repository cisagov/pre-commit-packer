#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

if [ -z "$(command -v packer)" ]; then
  echo "packer is required"
  exit 1
fi

# The version of readlink on macOS does not support long options
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
readonly SCRIPT_DIR
# shellcheck source=lib/util.sh
source "$SCRIPT_DIR/../lib/util.sh"

util::parse_cmdline "$@"

util::get_unique_directory_paths "${FILES[@]}"

error=0

for path in "${UNIQUE_PATHS[@]}"; do
  pushd "$path" > /dev/null

  packer init . > /dev/null
  if ! packer validate "${ARGS[@]}" .; then
    error=1
    echo
    echo "Failed path: $path"
    echo "================================"
  fi
done

if [[ $error -ne 0 ]]; then
  exit 1
fi
