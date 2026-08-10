#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

#######################################
# Process the command line and separate arguments from files
# Globals:
#   ARGS
#   FILES
#   NO_CD
#######################################
function util::parse_cmdline() {
  # Global variable arrays
  ARGS=()
  FILES=()
  export NO_CD=0

  while (("$#")); do
    case "$1" in
      --no-cd)
        NO_CD=1
        shift
        ;;
      -*)
        if [ -f "$1" ]; then
          FILES+=("$1")
        else
          ARGS+=("$1")
        fi
        shift
        ;;
      *)
        FILES+=("$1")
        shift
        ;;
    esac
  done
}

#######################################
# Create a list of unique directory paths from a list of file paths
# Globals:
#   UNIQUE_PATHS
#######################################
function util::get_unique_directory_paths() {
  # Global variable arrays
  UNIQUE_PATHS=()

  local -a paths

  index=0
  for file in "$@"; do
    paths[index]=$(dirname -- "$file")
    ((++index))
  done

  UNIQUE_PATHS=()
  while IFS='' read -r line; do UNIQUE_PATHS+=("$line"); done < <(printf '%s\n' "${paths[@]}" | sort --unique)
}
