export GPG_TTY=$(tty)

rmworktree() {
  local path
  local name="$1"
  shift
  path=$(/usr/bin/git worktree list --porcelain | /usr/bin/awk -v name="$name" '$1 == "worktree" && $2 ~ name {print $2}')
  if [[ -z "$path" ]]; then
    echo "No worktree matching '$name' found"
    return 1
  fi
  echo "Removing worktree: $path"
  /usr/bin/git worktree remove "$@" "$path"
}
