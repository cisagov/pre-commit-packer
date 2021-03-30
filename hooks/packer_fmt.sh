#!/usr/bin/env bash
set -e

declare -a paths

index=0

for file_with_path in "$@"; do
  file_with_path="${file_with_path// /__REPLACED__SPACE__}"

  paths[index]=$(dirname "$file_with_path")
  (("index+=1"))
done

for path_uniq in $(echo "${paths[*]}" | tr ' ' '\n' | sort -u); do
  path_uniq="${path_uniq//__REPLACED__SPACE__/ }"

  pushd "$path_uniq" > /dev/null
  packer fmt "$path_uniq"
  popd > /dev/null
done

# *.pkrvars.hcl not located in the main directory are excluded by `packer fmt`
IFS=
pkrvars_dir=$(dirname "$(find . -path ./git -prune -false -o -name '*.pkrvars.hcl' -print -quit)")
echo "$pkrvars_dir"
cd "$pkrvars_dir"
packer fmt .
