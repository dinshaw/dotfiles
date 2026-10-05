# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:/Users/dinshawgobhai/.docker/bin"
# End of Docker Desktop section.

#! /usr/bin/env bash

# Send to .bashrc for all settings.
if [[ -f $HOME/.bashrc ]]; then
  . $HOME/.bashrc
fi

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

. "$HOME/.cargo/env"
