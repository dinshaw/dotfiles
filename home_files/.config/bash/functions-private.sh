#! /usr/bin/env bash

#------------------#
# Section: General #
#------------------#

# Label: Clip and Print
# Description: Copy input to clipboard and print what what was copied (best used with a pipe).
# Parameters: $1 (optional) - Displays "(copied to cliboard)" on a new line. Default: false.
_copy_and_print() {
  local delimiter=${1:-' '}
  local message="$delimiter(copied to clipboard)\n"

  pbcopy && printf "%s" "$(pbpaste)" && printf "$message"
}

# Label: Print Black on White
# Description: Print black text on a white background.
# Parameters: $1 (required) - Content to print.
_print_black_on_white() {
  local content="$1"
  printf "\e[0;30m\e[48;5;255m$content\033[m"
}

# Label: Toggle Total Color
# Description: Format and conditionally color the total.
# Parameters: $1 (required) - The total, $2(required) - The label, $3 (required) - The color.
_toggle_total_color() {
  local total="$1"
  local label="$2"
  local color="$3"

  if [[ $total -gt 0 ]]; then
    printf "$color$total $label\033[m"
  else
    printf "$total $label"
  fi
}

#------------------------------------#
# Section: https://git-scm.com:[Git] #
#------------------------------------#

# Label: Git Branch Default
# Description: Print Git default branch.
_git_branch_default() {
  local default="$(git config --get init.defaultBranch)"
  printf "${default:-main}"
}

# Label: Git Branch Name
# Description: Print Git branch name.
_git_branch_name() {
  git branch --show-current | tr -d '\n'
}

# Label: Git Branch SHA
# Description: Answer SHA from which the branch was created.
_git_branch_sha() {
  local shas=($(_git_branch_shas))

  if [[ ${#shas[@]} != 0 ]]; then
    printf "%s" ${shas[-1]}
  fi
}

# Label: Git Branch SHAs
# Description: Answer branch commit SHAs regardless of branch nesting.
_git_branch_shas() {
  local ifs_original=$IFS
  IFS=$'\n'

  local log_format="%h%d"
  local current_commit=($(git log --pretty=format:$log_format) -1)
  local commits=($(git log --pretty=format:$log_format))
  local range="$(_git_commit_last)"
  local current_pattern=".*\(HEAD.+\)*"
  local parent_pattern=".*\(.+\)*"
  local origin_pattern=".*\(origin\/$(_git_branch_name)\)$"
  local default_pattern=".*\(.+$(_git_branch_default)(\,|\))*"

  if [[ ! "$current_commit" =~ $default_pattern ]]; then
    for entry in ${commits[@]}; do
      local entry_sha="${entry%% *}"

      if [[ ! "$entry" =~ $current_pattern && ! "$entry" =~ $origin_pattern ]]; then
        if [[ "$entry" =~ $default_pattern || "$entry" =~ $parent_pattern ]]; then
          range="$entry_sha..$(_git_commit_last)"
          break
        fi
      fi
    done
  fi

  git log --pretty=format:%h "$range"
  IFS=$ifs_original
}

# Label: Git Commit Count Since Last Tag
# Description: Answer commit count since last tag for project.
# Parameters: $1 (optional) - The output prefix. Default: null., $2 (optional) - The output suffix. Default: null.
_git_commit_count_since_last_tag() {
  local prefix="$1"
  local suffix="$2"
  local count=$(_git_commits_since_last_tag | wc -l | xargs -n 1)

  if [[ -n $count ]]; then
    if [[ -n "$prefix" ]]; then
      printf "\033[36m${prefix}\033[m: "
    fi

    if [[ $count -ge 30 ]]; then
      printf "\033[31m$count\033[m"
    elif [[ $count -ge 20 && $count -le 29 ]]; then
      printf "\033[1;31m$count\033[m"
    elif [[ $count -ge 10 && $count -le 19 ]]; then
      printf "\033[33m$count\033[m"
    else
      printf "$count"
    fi

    if [[ -n "$suffix" ]]; then
      printf "$suffix"
    fi
  fi
}

# Label: Git Commit Last
# Description: Answer last commit for current branch.
_git_commit_last() {
  git log --pretty=format:%h -1
}

# Label: Git Commit Options
# Description: Print options for interacting with Git commits.
# Parameters: $1 (required) - Commit array.
_git_commit_options() {
  local commits=("${1}")
  local commit_total=${#commits[@]}
  local option_padding=${#commit_total}
  local counter=1

  unset response

  if [[ ${#commits[@]} == 0 ]]; then
    printf "%s\n" "No commits found."
    return 0
  fi

  for commit in ${commits[@]}; do
    local option="$(printf "%${option_padding}s" $counter)"
    printf "%s\n" "$option: $(git log --color --pretty=format:"$(_git_log_line_format)" -n1 $commit)"
    counter=$((counter + 1))
  done
}

# Label: Git Commit Root
# Description: Answer root commit of entire repository.
_git_commit_root() {
  git rev-list --pretty=format:%h --max-parents=0 HEAD | rg --invert-match "^commit"
}

# Label: Git Commits Since Last Tag
# Description: Answer commit history since last tag for project.
_git_commits_since_last_tag() {
  if [[ $(git tag) ]]; then
    git log --oneline --reverse --format='%C(yellow)%h%Creset %s' $(git describe --abbrev=0 --tags --always)..HEAD
  else
    git log --oneline --reverse --format='%C(yellow)%h%Creset %s'
  fi
}

# Label: Git File Commits
# Description: Print file commit history (with optional diff support).
# Parameters: $1 (required) - The file path.
_git_file_commits() {
  local commits=("${!1}")
  local file="$2"
  local commit_total=${#commits[@]}
  local option_padding=${#commit_total}
  local counter=1

  _git_commit_options "${commits[*]}"

  read -r -p "Enter selection: " response
  if [[ "$response" == 'q' ]]; then
    return
  fi

  printf "\n"
  local selected_commit=${commits[$((response - 1))]}
  _git_show_details $selected_commit

  printf "\n"
  read -p "View diff (y = yes, n = no)? " response
  if [[ "$response" == 'y' ]]; then
    gdt $selected_commit^! -- "$file"
  fi
}

# Label: Git Last Tag Info
# Description: Answer last tag for project (including commits added since tag was created).
_git_last_tag_info() {
  printf "%s\n" "$(git describe --tags --always) ($(_git_commit_count_since_last_tag) commits since)"
}

# Label: Git Log Details Format
# Description: Prints default log format.
_git_log_details_format() {
  printf "%s" "$(_git_log_line_format) %n%n%b%n%N%-%n"
}

# Label: Git Log Line Format
# Description: Print single line log format.
_git_log_line_format() {
  printf "%s" "%C(yellow)%h%C(reset) %G? %C(bold blue)%an%C(reset) %s%C(bold cyan)%d%C(reset) %C(green)%cr.%C(reset)"
}

# Label: Git Show Details
# Description: Show commit/file change details in a concise format.
# Parameters: $1 (required) - The params to pass to git show.
_git_show_details() {
  git show --stat --pretty=format:"$(_git_log_details_format)" $@
}

# Label: Git Stash Count
# Description: Answer total stash count for current project.
_git_stash_count() {
  git stash list | wc -l | xargs -n 1
}

# Label: Git Stash
# Description: Enhance default git stash behavior by prompting for input (multiple) or using last stash (single).
# Parameters: $1 (required) - The Git stash command to execute, $2 (required) - The prompt label (for multiple stashes).
_process_git_stash() {
  local stash_command="$1"
  local stash_index=0
  local prompt_label="$2"
  local ifs_original=$IFS
  IFS=$'\n'

  stashes=($(gashl))

  if [[ ${#stashes[@]} == 0 ]]; then
    printf "%s\n" "Git stash is empty. Nothing to do."
    return 0
  fi

  if [[ ${#stashes[@]} -gt 1 ]]; then
    printf "%s\n" "$prompt_label:"
    for ((index = 0; index < ${#stashes[*]}; index++)); do
      printf "  %s\n" "$index: ${stashes[$index]}"
    done
    printf "  %s\n\n" "q: Quit/Exit."

    read -p "Enter selection: " response

    local match="^[0-9]{1}$"
    if [[ "$response" =~ $match ]]; then
      printf "\n"
      stash_index="$response"
    else
      return 0
    fi
  fi

  IFS=$ifs_original
  eval "$stash_command stash@{$stash_index}"
}
