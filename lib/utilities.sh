#! /usr/bin/env bash

link_files() {
  printf "%s\n" "Linking dotfiles..."

  for file in $(home_files); do
    link_file "$file"
  done

  printf "%s\n" "Dotfiles link complete!"
}

link_file() {
  local source_file="$PWD/$1"
  local dest_file="$HOME/$(base_dest_file "$1")"
  local dest_dir="$(dirname "$dest_file")"
  local excludes=".+(env.sh|git/configuration)$"

  if [[ "$(basename "$source_file")" == "mkdir.command" ]]; then
    mkdir -p "$dest_dir"
    return
  fi

  if [[ ! "$source_file" =~ $excludes ]]; then
    mkdir -p "$dest_dir"
    ln -sf "$source_file" "$dest_file"
    printf "  %s -> %s\n" "$dest_file" "$source_file"
  fi
}

home_files() {
  find home_files -type f | while read -r file; do
    printf "%s\n" "$file"
  done
}

base_dest_file() {
  printf "%s" "$1" | sed 's|^home_files/||'
}
