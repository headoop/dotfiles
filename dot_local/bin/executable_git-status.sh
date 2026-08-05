#!/usr/bin/bash

echo ""
echo "unclean git repos at ~/git/"
echo ""

# unset IFS while in the while loop
# read is understanding $'\0' as the null terminator
while IFS= read -r -d $'\0' file; do
  # remove leading dot and slash: './'
  file="${file#./}"
  cd "$file"
  STATUS=$(git status --short 2>/dev/null)
  git status --short &>/dev/null
  RET=$?
  if [ $RET = 128 ]; then
    echo "not a git directory: $file"
  elif [ ! -z "$STATUS" ]; then
    echo "$file"
  fi
done < <(find ~/git/ -mindepth 1 -maxdepth 1 -type d -print0)
