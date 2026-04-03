#! /usr/bin/env bash

#------------------#
# Section: General #
#------------------#

# Label: Colorized Type
# Description: Identical to "type" system command but with Bat support.
# Parameters: $1 (required) - The alias or function to inspect source code for.
cype() {
  local name="$1"

  if [[ -n "$name" ]]; then
    type "$name" | cat --language "bash"
  fi
}

# Label: Kill Process
# Description: Kill errant/undesired process.
# Parameters: $1 (required) - The search query, $2 (optional) - The signal. Default: 15.
kilp() {
  local query="$1"
  local signal=${2:-15}

  pkill -$signal -l -f "$query"
}

# Label: Port
# Description: List file activity on given port.
# Parameters: $1 (required) - The port number.
port() {
  if [[ "$1" ]]; then
    lsof -i :$1 +c0
  else
    printf "%s\n" "ERROR: Port number must be supplied."
  fi
}

# Label: Minitest Debug
# Description: Debug intermittent test failure(s) by running test until failure is detected.
# Parameters: $1 (required) - The test file.
mtd() {
  local test_file=$1

  while [ $? == 0 ]; do
    bundle exec rails test "$test_file"
  done
}

#------------------------------------#
# Section: https://git-scm.com:[Git] #
#------------------------------------#

# Label: Git Safe
# Description: Marks repository as safe for auto-loading project's `bin` path.
gafe() {
  if [[ -d ".git" ]]; then
    mkdir -p .git/safe
    printf "%s\n" "Repository has been marked safe."
    exec "$HOMEBREW_PREFIX/bin/bash"
  fi
}

# Label: Git Stash
# Description: Creates stash of all changes.
# Parameters: $1 (optional) - Label. Default: "All Work (YYYY-MM-DD HH:MM:SS AM|PM Z)."
gash() {
  local label=${1:-"All Work ($(date '+%Y-%m-%d %r %Z'))."}
  git stash push --include-untracked --message "$label"
}

# Label: Git Stash Drop
# Description: Drop stash or prompt for stash to drop.
gashd() {
  _process_git_stash "git stash drop" "Git Stash Drop Options (select stash to drop)"
}

# Label: Git Stash List
# Description: List stashes.
gashl() {
  git stash list --pretty=format:'%C(magenta)%gd%C(reset) %C(yellow)%h%C(reset) %s %C(green)(%cr)%C(reset)'
}

# Label: Git Stash Pop
# Description: Pop stash or prompt for stash to pop.
gashp() {
  _process_git_stash "git stash pop" "Git Stash Pop Options (select stash to pop)"
}

# Label: Git Stash Show
# Description: Show stash or prompt for stash to show.
# Parameters: $1 (optional) - Show git diff. Default: skipped.
gashs() {
  local stash=($(git stash list))
  local diff_option="$1"

  if [[ -n "$diff_option" ]]; then
    case "$diff_option" in
      'd')
        _process_git_stash "git stash show --patch" "Git Stash Diff Options (select stash to diff)";;
      't')
        _process_git_stash "git difftool" "Git Stash Diff Options (select stash to diff)";;
      *)
        printf "%s\n\n" "Usage: gashs OPTION"
        printf "%s\n" "Available options:"
        printf "%s\n" "  d: Git diff."
        printf "%s\n" "  t: Git difftool."
        return;;
    esac
  else
    _process_git_stash "_git_show_details" "Git Stash Show Options (select stash to show)"
  fi
}

# Label: Git Stash (stage)
# Description: Creates stash of staged work.
# Parameters: $1 (optional) - Label. Default: "Staged Work (YYYY-MM-DD HH:MM:SS AM|PM Z)."
gasht() {
  local label=${1:-"Staged Work ($(date '+%Y-%m-%d %r %Z'))."}
  git stash push --stage --message "$label"
}

# Label: Git Branch Create
# Description: Create and switch to branch.
# Parameters: $1 (required) - New branch name.
gbc() {
  local name="$1"

  if [[ "$name" ]]; then
    git switch --create "$name" --track
  else
    printf "%s\n" "ERROR: Branch name must be supplied."
    return 1
  fi
}

# Label: Git Fixup
# Description: Select recent commit via fzf and create a fixup commit for it.
fixup() {
  local sha=$(git log -n 50 --pretty=format:'%h %s' --no-merges | fzf | cut -c -7)
  if [[ -n "$sha" ]]; then
    git commit --fixup "$sha"
  fi
}

# Label: Git Branch Delete
# Description: Interactively delete local and/or remote branch.
gbd() {
  local branch="$(gbl | fzf | awk '{print $1}')"

  if [[ -n "$branch" ]]; then
    gbdl "$branch"
    gbdr "$branch"
  fi
}

# Label: Git Branch Delete (local)
# Description: Delete local branch.
# Parameters: $1 (required) - Branch name.
gbdl() {
  local branch="$1"

  if [[ -n "$(git branch --list $branch)" ]]; then
    printf "\033[31m" # Red.
    read -p "Delete \"$branch\" local branch (y/n)?: " response
    printf "\033[m" # White.

    if [[ "$response" == 'y' ]]; then
      git branch --delete --force "$branch"
    else
      printf "%s\n" "Local branch deletion aborted."
    fi
  else
    printf "%s\n" "Local branch not found."
  fi
}

# Label: Git Branch Delete (merged)
# Description: Delete remote and local merged branches.
gbdm() {
  if [[ $(_git_branch_name) != "$(_git_branch_default)" ]]; then
    printf "%s\n" "ERROR: Whoa, switch to default branch first."
    return 1
  fi

  # Remote
  git branch --remotes \
             --merged \
             | rg "origin" \
             | rg --invert-match "$(_git_branch_default)" \
             | sed 's/origin\///' \
             | xargs -n 1 git push --delete origin

  # Local
  git branch --merged | rg --invert-match "\* $(_git_branch_default)" | xargs -n 1 git branch --delete --force
}

# Label: Git Branch Delete (remote)
# Description: Delete remote branch.
# Parameters: $1 (required) - Branch name.
gbdr() {
  local branch="$1"

  if [[ -n "$(git branch --remotes --list origin/$branch)" ]]; then
    printf "\033[31m" # Red.
    read -p "Delete \"$branch\" remote branch (y/n)?: " response
    printf "\033[m" # White.

    if [[ "$response" == 'y' ]]; then
      git push --delete origin "$branch"
    else
      printf "%s\n" "Remote branch deletion aborted."
    fi
  else
    printf "%s\n" "Remote branch not found."
  fi
}

# Label: Git Branch List
# Description: List local and remote branch details.
gbl() {
  local format="%(refname)|%(color:yellow)%(objectname:short)|%(color:reset)|%(color:blue bold)%(authorname)|%(color:green)|%(committerdate:relative)"

  git for-each-ref --sort="authordate:iso8601" \
                   --sort="authorname" \
                   --color \
                   --format="$format" refs/heads refs/remotes/origin \
                   | sed '/HEAD/d' \
                   | sed 's/refs\/heads\///g' \
                   | sed 's/refs\/remotes\/origin\///g' \
                   | uniq \
                   | sort \
                   | column -s'|' -t
}

# Label: Git Branch Rename
# Description: Rename current branch.
# Parameters: $1 (required) - Branch name.
gbr() {
  local new_branch="$1"
  local old_branch="$(_git_branch_name)"

  git branch --track --move "$new_branch"

  if [[ -n "$(git branch --remotes --list origin/$old_branch)" ]]; then
    printf "\033[31m" # Red.
    read -p "Delete \"$old_branch\" remote branch (y/n)?: " response
    printf "\033[m" # White.

    if [[ "$response" == 'y' ]]; then
      git push --delete origin "$old_branch"
      git push --set-upstream origin "$new_branch"
    fi
  fi
}

# Label: Git Branch Switch
# Description: Switch between branches.
gbs() {
  gbl | fzf | awk '{print $1}' | xargs git switch
}

# Label: Git Commit Breakpoint
# Description: Create a breakpoint (empty) commit to denote related commits in a feature branch.
# Parameters: $1 (optional) - A custom label. Default: "Breakpoint"
gcb() {
  local label="${1:-Breakpoint}"
  git commit --allow-empty --no-verify --message "----- $label -----"
}

# Label: Git Commit Fixup
# Description: Create fixup commit with optional amend or reword support.
# Parameters: $1 (required) - SHA, $2 (optional) - (a)mend or (r)eword.
gcf() {
  local sha="$1"
  local kind="$2"

  if [[ -z "$sha" ]]; then
    printf "%s\n" "ERROR: SHA is missing."
    return
  fi

  case $kind in
    'a')
      git commit --fixup=amend:"$sha";;
    'r')
      git commit --fixup=reword:"$sha";;
    *)
      git commit --fixup "$sha";;
  esac
}

# Label: Git Commit Fix (file)
# Description: Create commit fix for file (ignores previous fixups).
# Parameters: $1 (required) - The file to create fixup commit for.
gcff() {
  local file_path="$1"
  local file_sha="$(git log --grep 'fixup!' --invert-grep --pretty=format:%h -1 $file_path)"

  if [[ "($(_git_branch_shas))" == *"$file_sha"* ]]; then
    git add "$file_path" && git commit --fixup "$file_sha"
  fi
}

# Label: Git Commit Fix (interactive)
# Description: Select which commit to fix within current feature branch.
# Parameters: $1 (optional) - (a)mend or (r)eword.
gcfi() {
  local kind="$1"
  local commits=($(_git_branch_shas))

  local commit=$(_git_commit_options "${commits[*]}" | fzf | sed -E 's/^([0-9]+):/\1/' | awk '{print $1}' )

  printf "\n"
  local selected_commit=${commits[$((commit - 1))]}
  printf "%s\n" "Selected commit: $selected_commit"
  gcf "$selected_commit" "$kind"
}

# Label: Git Reset Hard
# Description: Reset to HEAD, destroying all untracked, staged, and unstaged changes. UNRECOVERABLE!
# Parameters: $1 (optional) - The number of commits to reset or a specific commit SHA.
gesh() {
  local value="$1"
  local number_pattern="^[0-9]+$"
  local commit_pattern="^[a-f0-9]+$"

  git clean --force --quiet -d

  if [[ "$value" =~ $number_pattern ]]; then
    git reset --hard "HEAD~${value}"
  elif [[ "$value" =~ $commit_pattern ]]; then
    git reset --hard "${value}"
  else
    git reset --hard HEAD
  fi
}

# Label: Git Reset Soft
# Description: Resets previous commit (default), resets back to number of commits, or resets to specific commit.
# Parameters: $1 (optional) - The number of commits to reset or a specific commit SHA.
gess() {
  local value="$1"
  local number_pattern="^[0-9]+$"
  local commit_pattern="^[a-f0-9]+$"

  if [[ "$value" =~ $number_pattern ]]; then
    git reset --soft "HEAD~${value}"
  elif [[ "$value" =~ $commit_pattern ]]; then
    git reset --soft "${value}"
  else
    git reset --soft HEAD^
  fi
}

# Label: Git Show
# Description: Show commit details with optional diff support.
# Parameters: $1 (optional) - The commit to show. Default: <last commit>, $2 (optional) - Launch difftool. Default: false.
ghow() {
  local commit="$1"
  local difftool="$2"

  if [[ -n "$commit" && -n "$difftool" ]]; then
    _git_show_details "$commit"
    git difftool "$commit^" "$commit"
  elif [[ -n "$commit" && -z "$difftool" ]]; then
    _git_show_details "$commit"
  else
    _git_show_details
  fi
}

# Label: Git Log Details
# Description: List default or feature branch commit details.
gld() {
  if [[ "$(_git_branch_name)" == "$(_git_branch_default)" ]]; then
    git log --stat --pretty=format:"$(_git_log_details_format)"
    return
  fi

  local commits=($(_git_branch_shas))

  if [[ ${#commits[@]} == 1 ]]; then
    _git_show_details "${commits[0]}"
  else
    git log --stat --pretty=format:"$(_git_log_details_format)" "${commits[-1]}^..${commits[0]}"
  fi
}

# Label: Git Log (interactive)
# Description: List default or feature branch commits with commit show and/or diff support.
gli() {
  local commits=($(_git_branch_shas))

  _git_commit_options "${commits[*]}"

  printf "\n"
  read -p "Enter selection or quit (q): " response
  if [[ "$response" == 'q' ]]; then
    return
  fi

  local selected_commit=${commits[$((response - 1))]}
  printf "%s\n" "$(_git_show_details $selected_commit)"

  printf "\n"
  read -p "View diff (y = yes, n = no)? " response
  if [[ "$response" == 'y' ]]; then
    gdt $selected_commit^!
  fi
}

# Label: Git Commit Count
# Description: Answer total number of commits for current project.
gount() {
  printf "Commits: "
  git rev-list --count HEAD
}

# Label: Git Push
# Description: Pushes changes to remote repository with dynamic branch creation if non-existent.
gp() {
  local branch="$(_git_branch_name)"

  if [[ "$(git config --get branch.$branch.remote)" == "." ]]; then
    git push --set-upstream origin "$branch"
  else
    git push
  fi
}

# Label: Git Remote Add
# Description: Add and track a remote repository.
# Parameters: $1 (required) - Repository URL, $2 (optional) - Name. Default: upstream
gra() {
  local url="$1"
  local name="${2:-upstream}"

  if [[ -z "$url" ]]; then
    printf "%s\n" "ERROR: Repository URL must be supplied."
    return 1
  fi

  git remote add -t "$(_git_branch_default)" -f "$name" "$url"
}

# Label: Git Rebase (interactive)
# Description: Rebase commits, interactively.
# Parameters: $1 (optional) - The number of commits or label (i.e. branch/tag) to rebase to.
grbi() {
  local number_pattern="^[0-9]+$"
  local label_pattern="^[0-9a-zA-Z\_-]+$"
  local parent_sha=$(git log --pretty=format:%h -n 1 "$(_git_branch_sha)^" 2> /dev/null || :)
  local value="${1:-$parent_sha}"

  if [[ "$value" =~ $number_pattern ]]; then
    git rebase --keep-empty --interactive "@~${value}"
  elif [[ "$(_git_branch_name)" == "$(_git_branch_default)" && -z "$(git config remote.origin.url)" ]]; then
    git rebase --keep-empty --interactive --root
  elif [[ "$value" =~ $label_pattern ]]; then
    git rebase --keep-empty --interactive "$value"
  else
    printf "%s\n" "Invalid commit SHA, branch label, or repo has remote: $value."
    return 1
  fi
}

# Label: Git Rebase (quick)
# Description: Rebase commits, quickly. Identical to `grbi` function but skips editor.
# Parameters: $1 (optional) - The commit number or branch to rebase to. Default: upstream or root.
grbq() {
  GIT_EDITOR=true grbi "$1"
}

# Label: Git Root
# Description: Change to repository root directory regardless of current depth.
groot() {
  cd "$(git rev-parse --show-toplevel)"
}

# Label: Git Sync
# Description: Syncs up remote changes and deletes pruned/merged branches.
gync() {
  if [[ $(_git_branch_name) != "$(_git_branch_default)" ]]; then
    printf "%s\n" "ERROR: Whoa, switch to default branch first."
    return 1
  fi

  git pull && gbdm
}
