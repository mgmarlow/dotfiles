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
      if (!collecting) {
        print "## " file
        print "Comment:"
        collecting = 1
      }
      print " " substr($0, 3)
      next
    }
    collecting {
      print "Context:"
      if (p1 != "") print "  " p1
      if (p2 != "") print "  " p2
      collecting = 0
      pending = 2
    }
    pending {
      print "  " $0
      if (!--pending) print ""
      next
    }
    { p1 = p2; p2 = $0 }
    END {
      if (collecting) {
        print "Context:"
        if (p1 != "") print "  " p1
        if (p2 != "") print "  " p2
      }
    }
  ' "$file"
}

