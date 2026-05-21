review() {
  emulate -L zsh
  setopt local_options pipe_fail

  local review_dir="${REVIEW_DIR:-$HOME/.local/share/code-review}"
  mkdir -p "$review_dir" || return 1
  local out="$review_dir/review-$(date +%Y%m%d-%H%M%S).diff"

  {
    cat <<'EOF'
# Add comments by inserting lines starting with "#:" anywhere below.
# Example:
#   #: this branch should handle the None case
# Save and quit when done. Run `review-extract` to collect comments.
#
EOF
    if [[ -t 0 && $# -gt 0 ]]; then
      cat -- "$1"
    else
      cat
    fi
  } > "$out" || return 1

  "${EDITOR:-vim}" "$out" || return 1

    # Extract and copy to clipboard
  local extracted
  extracted=$(review-extract "$out") || return 1

  if [[ -z "$extracted" ]]; then
    print -u2 -- "No comments found in $out"
    return 0
  fi

  echo -n "$extracted" | pbcopy

  local count=$(print -- "$extracted" | grep -c '^Comment:')
  print -- "Copied $count comment(s) to clipboard. Source: $out"
}

review-extract() {
  emulate -L zsh
  setopt local_options pipe_fail

  local file="$1"
  if [[ -z "$file" ]]; then
    local review_dir="${REVIEW_DIR:-$HOME/.local/share/code-review}"
    file=( "$review_dir"/review-*.diff(.Nom[1]) )
    [[ -f "$file" ]] || { print -u2 -- "No review file found"; return 1 }
  fi

  awk '
    /^\+\+\+ b\// { file = substr($0, 7); next }
    /^#:/ {
      print "## " file
      print "Comment:" substr($0, 3)
      print "Context:"
      # Print last 2 buffered lines (the 2 before the comment)
      start = (n > 2) ? n - 1 : 1
      for (i = start; i <= n; i++) print "  " buf[i]
      pending = 2
      next
    }
    pending > 0 {
      print "  " $0
      if (--pending == 0) print ""
      next
    }
    {
      buf[++n] = $0
      if (n > 2) { buf[1] = buf[2]; buf[2] = buf[3]; n = 2 }
    }
  ' "$file"
}

