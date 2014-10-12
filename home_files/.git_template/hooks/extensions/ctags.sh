#!/bin/bash

# Label: CTags Rebuild
# Description: Rebuilds the CTag .tags file in the project root.
function ctags_rebuild() {
  local label="[ctags]"
  local git_root="$(dirname $(git rev-parse --git-dir))"
  local tag_file="$git_root/.tags"

  if command -v ctags > /dev/null; then
    rm -f "$tag_file"
    ctags --recurse --tag-relative --languages=-javascript,sql -f $tag_file
    printf "$label: CTags rebuilt.\n"
  else
     printf "$label: Exuberant CTags not found. To install, run: brew install ctags."
     exit 1
  fi
}
