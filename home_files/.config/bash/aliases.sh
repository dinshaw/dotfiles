#! /usr/bin/env bash

# Bash
alias bashe="$EDITOR $HOME/.config/bash/env.sh"
alias bashs="exec $SHELL"

# direnv
alias denva="direnv allow"
alias denvr="direnv reload"
alias denvs="direnv status"

# Eza
alias x1="eza --oneline --all --group-directories-first"
alias x="eza --all --all --long --header --group --group-directories-first --time-style long-iso --git"
alias xt="eza --all --group-directories-first --ignore-glob '*.git' --git-ignore --tree"

# Fuzzy Finder
alias ff="fzf --preview 'bat --theme DarkNeon --color always {}' | xargs $EDITOR"

# General
alias ..="cd .."
alias ...="cd ../.."
alias c="clear"
alias cat="bat --theme DarkNeon"
alias cdb="cd -"
alias du="ncdu -e --color dark"
alias h="history"
alias l="ls -alhT"
alias o="open"
alias rmde="find . -type d -empty -not -path '*.git*' -delete"

# Git
alias ga="git add"
alias gall="git add --all ."
alias gamend="git commit --amend"
alias gap="git add --patch"
alias gashc="git stash clear"
alias gb="git switch"
alias gbb="git switch -"
alias gbm='git switch $(_git_branch_default)'
alias gcm="git commit --message"
alias gco="git commit"
alias gd="git diff"
alias gdc="git diff --cached"
alias gdm='git diff origin/$(_git_branch_default)'
alias gdo='git diff --name-only | uniq | xargs $EDITOR'
alias gdw="git diff --color-words"
alias gf="git fetch"
alias gdt="git difftool"
alias gl='git log --graph --pretty=format:"$(_git_log_line_format)"'
alias gln='git log --graph --pretty=format:"$(_git_log_line_format)" --name-only'
alias gpf="git push --force-with-lease"
alias gpo="git push --set-upstream origin"
alias gpu="git pull"
alias gpuo="git pull origin"
alias gpuom='git pull origin $(_git_branch_default)'
alias gr="git restore"
alias gst="git status --short --branch"

# Rails
alias railsb="rails console --sandbox"
alias railse="EDITOR='e --wait' rails credentials:edit"
alias rdbm="rails db:migrate"
alias rdbmt="RAILS_ENV=test rails db:migrate"
alias rt="bundle exec rails test"
alias rts="bundle exec rails test:system"
alias r5="bundle exec rails s -p 5555"

# Editor
alias e="cursor"
