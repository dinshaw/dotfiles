#! /usr/bin/env bash

if [[ BASH_VERSINFO[0] < 4 ]]; then
  printf "%s\n" "WARNING: Dotfiles requires Bash 4.x.x or higher to work correctly."
fi

# Checks the window size after each command and, if necessary, updates LINES and COLUMNS values.
shopt -s checkwinsize

# Attempts to save all lines of a multi-line command as a single history entry for easy re-editing.
shopt -s cmdhist

# Attempts word spelling correction on directory names if directory name supplied does not exist.
shopt -s dirspell

# Enables extended pattern matching features.
shopt -s extglob

# Using ** in a pathname expansion context will match all files and zero or more directories and
# subdirectories. If the pattern is followed by a /, only directories and subdirectories match.
shopt -s globstar

# The history list is appended (instead of being overwritten) as defined by the HISTFILE variable.
shopt -s histappend

# Editors
export VISUAL="cursor --wait"
export EDITOR="$VISUAL"

# History
export HISTFILE="$HOME/.config/bash/history.log"
export HISTTIMEFORMAT="%F %T "
export HISTCONTROL="erasedups:ignoreboth"
export HISTSIZE=10000
export HISTIGNORE="#*:..:...:c:h:l:l1:p:pwd:gst:gd:exit:* --help"

# Homebrew
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export HOMEBREW_BAT=1
export HOMEBREW_BOOTSNAP=1
export HOMEBREW_CURL_RETRIES=3
export HOMEBREW_FORCE_BREWED_CURL=1
export HOMEBREW_FORCE_BREWED_GIT=1
export HOMEBREW_INSTALL_FROM_API=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_PREFIX="$(brew --prefix)"
export RUBY_CONFIGURE_OPTS="--enable-yjit"

# Postgres
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Environment
source "$HOME/.config/bash/env.sh"

# Colors
source "$HOME/.config/bash/colors.sh"

# Aliases
source "$HOME/.config/bash/aliases.sh"

# Functions
source "$HOME/.config/bash/functions-private.sh"
source "$HOME/.config/bash/functions-public.sh"

# Command Prompt
source "$HOME/.config/bash/prompt.sh"

# Bash Completion
if type brew &>/dev/null
then
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi

# Docker
export DOCKER_CONFIG="$HOME/.config/docker"

# OpenSSL
export PATH="$HOMEBREW_PREFIX/opt/openssl/bin:$PATH"

# GPG
export GPG_TTY=$(tty)

# direnv
if [[ -e "$HOMEBREW_PREFIX/bin/direnv" ]]; then
  eval "$(direnv hook bash)"
fi

# mise
if [[ -e "$HOMEBREW_PREFIX/bin/mise" ]]; then
  eval "$(mise activate bash)"
fi

# FZF
export FZF_DEFAULT_COMMAND="fd --type file --follow --hidden --color always --exclude .git"
export FZF_DEFAULT_OPTS="--multi --ansi"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Git
export GIT_CONFIG_GLOBAL="$HOME/.config/git/configuration"

if [[ -r "$HOMEBREW_PREFIX/opt/git/etc/bash_completion.d/git-completion.bash" ]]; then
  source "$HOMEBREW_PREFIX/opt/git/etc/bash_completion.d/git-completion.bash"
fi

export PATH=".git/safe/../../bin:$PATH"

# Zoxide
export _ZO_DATA_DIR="$HOME/.cache/zoxide"
eval "$(zoxide init bash)"

ulimit -Sn 10240

# Rust
export PATH="$HOME/.local/bin:$PATH"
. "$HOME/.cargo/env"
