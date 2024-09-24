#!/usr/bin/env bash

# bump_version.sh [--push] [--label LABEL] (major | minor | patch | prerelease | build | finalize | show)

set -o nounset
set -o errexit
set -o pipefail

VERSION_FILE=config/version.txt
README_FILE=README.md

HELP_INFORMATION="bump_version.sh [--push] [--label LABEL] (major | minor | patch | prerelease | build | finalize | show)"

old_version=$(< "$VERSION_FILE")
new_version="$old_version"

bump_part=""
label=""
commit_prefix="Bump"
with_push=false
commands_with_label=("build" "prerelease")
commands_with_prerelease=("major" "minor" "patch")
with_prerelease=false

#######################################
# Display an error message, the help information, and exit with a non-zero status.
# Arguments:
#   Error message.
#######################################
function invalid_option() {
  echo "$1"
  echo "$HELP_INFORMATION"
  exit 1
}

#######################################
# Bump the version using the provided command.
# Arguments:
#   The version to bump.
#   The command to bump the version.
# Returns:
#   The new version.
#######################################
function bump_version() {
  local temp_version
  temp_version=$(python -c "import semver; print(semver.parse_version_info('$1').${2})")
  echo "$temp_version"
}

if [ $# -eq 0 ]; then
  echo "$HELP_INFORMATION"
else
  while [ $# -gt 0 ]; do
    case $1 in
      --push)
        if [ "$with_push" = true ]; then
          invalid_option "Push has already been set."
        fi

        with_push=true
        shift
        ;;
      --label)
        if [ -n "$label" ]; then
          invalid_option "Label has already been set."
        fi

        label="$2"
        shift 2
        ;;
      build | finalize | major | minor | patch)
        if [ -n "$bump_part" ]; then
          invalid_option "Only one version part should be bumped at a time."
        fi

        bump_part="$1"
        shift
        ;;
      prerelease)
        with_prerelease=true
        shift
        ;;
      show)
        echo "$old_version"
        exit 0
        ;;
      *)
        invalid_option "Invalid option: $1"
        ;;
    esac
  done
fi

if [ -n "$label" ] && [ "$with_prerelease" = false ] && [[ ! " ${commands_with_label[*]} " =~ [[:space:]]${bump_part}[[:space:]] ]]; then
  invalid_option "Setting the label is only allowed for the following commands: ${commands_with_label[*]}"
fi

if [ "$with_prerelease" = true ] && [[ ! " ${commands_with_prerelease[*]} " =~ [[:space:]]${bump_part}[[:space:]] ]]; then
  invalid_option "Changing the prerelease is only allowed in conjunction with the following commands: ${commands_with_prerelease[*]}"
fi

label_option=""
if [ -n "$label" ]; then
  label_option="token='$label'"
fi

if [ -n "$bump_part" ]; then
  if [ "$bump_part" = "finalize" ]; then
    commit_prefix="Finalize"
    bump_command="finalize_version()"
  elif [ "$bump_part" = "build" ]; then
    bump_command="bump_${bump_part}($label_option)"
  else
    bump_command="bump_${bump_part}()"
  fi
  new_version=$(bump_version "$old_version" "$bump_command")
  echo Changing version from "$old_version" to "$new_version"
fi

if [ "$with_prerelease" = true ]; then
  bump_command="bump_prerelease($label_option)"
  temp_version=$(bump_version "$new_version" "$bump_command")
  echo Changing version from "$new_version" to "$temp_version"
  new_version="$temp_version"
fi

tmp_file=/tmp/version.$$
sed "s/$old_version/$new_version/" $VERSION_FILE > $tmp_file
mv $tmp_file $VERSION_FILE
sed "s/$old_version/$new_version/" $README_FILE > $tmp_file
mv $tmp_file $README_FILE
git add $VERSION_FILE $README_FILE
git commit --message "$commit_prefix version from $old_version to $new_version"

if [ "$with_push" = true ]; then
  git push
fi
