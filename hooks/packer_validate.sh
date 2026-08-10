#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

function packer_validate() {
  local exit_code=0

  packer init "$1" > /dev/null

  # Allow us to get output if the validation fails
  set +o errexit
  validate_output=$(packer validate "${ARGS[@]}" "$1" 2>&1)
  exit_code=$?
  set -o errexit

  if [[ $exit_code -ne 0 ]]; then
    echo "Validation failed in $path"
    echo -e "$validate_output\n\n"
  fi

  return $exit_code
}

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

pids=()
for path in "${UNIQUE_PATHS[@]}"; do
  # Check each path in parallel
  {
    if [[ $NO_CD -eq 1 ]]; then
      packer_validate "$path"
    else
      pushd "$path" > /dev/null
      packer_validate .
    fi
  } &
  pids+=("$!")
done

error=0
exit_code=0
for pid in "${pids[@]}"; do
  wait "$pid" || exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    error=1
  fi
done

if [[ $error -ne 0 ]]; then
  exit 1
fi
