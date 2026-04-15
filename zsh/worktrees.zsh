# Git worktree helpers for zsh.
#
# Load from ~/.zshrc:
#   [ -f ~/.zsh/worktrees.zsh ] && source ~/.zsh/worktrees.zsh
#
# Commands:
#   wt-list           List linked worktrees as: <branch> <path>
#   wt-add [branch]   Create a worktree for a branch if one does not exist
#   wt-rm <branch>    Remove the worktree associated with a branch
#
# Configuration:
#   WT_ROOT           Base directory for new worktrees created by wt-add
#                     Default: .claude/worktrees
#
# Notes:
#   - wt-list excludes the primary repo worktree.
#   - wt-add ignores main/master/trunk and detached HEAD.
#   - These helpers assume wt-list output is branch first, path second.

wt-list() {
  git worktree list --porcelain | awk '
    /^worktree / {
      wt_path = substr($0, 10)
      branch = ""
      detached = 0
      count++
    }
    /^branch refs\/heads\// { branch = substr($0, 19) }
    /^detached$/ { detached = 1 }
    /^$/ {
      if (count > 1 && wt_path != "") {
        if (branch == "" && detached) branch = "(detached)"
        print branch, wt_path
      }
      wt_path = branch = ""
      detached = 0
    }
    END {
      if (count > 1 && wt_path != "") {
        if (branch == "" && detached) branch = "(detached)"
        print branch, wt_path
      }
    }
  '
}

# Set WT_ROOT for alternative worktree locations.
wt-add() {
  local b base
  b="${1:-$(git branch --show-current)}" || return
  base="${WT_ROOT:-.claude/worktrees}"

  case "$b" in
    ""|main|master|trunk) return 0 ;;
  esac

  wt-list | awk -v b="$b" '$1 == b { found = 1 } END { exit found ? 0 : 1 }' ||
    git worktree add "$base/$b" "$b"
}

wt-rm() {
  local b wt_path
  b="${1:-$(git branch --show-current)}" || return

  wt_path=$(wt-list | awk -v b="$b" '$1 == b { print $2; exit }')
  [ -n "$wt_path" ] || {
    printf 'no worktree found for branch: %s\n' "$b" >&2
    return 1
  }

  git worktree remove "$wt_path"
}
