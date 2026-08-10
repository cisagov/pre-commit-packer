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

pids=()
for path in "${UNIQUE_PATHS[@]}"; do
  # Check each path in parallel
  {
    packer fmt "${ARGS[@]}" -- "$path"
  } &
  pids+=("$!")
done

exec 3>&1 < /dev/tty > /dev/tty
tty_settings=$(stty -g)

error=0
exit_code=0
for pid in "${pids[@]}"; do
  wait "$pid" || exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    error=1
  fi
done

stty "$tty_settings"

if [[ $error -ne 0 ]]; then
  exit 1
fi
