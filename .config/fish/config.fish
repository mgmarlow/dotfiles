#!/usr/bin/env fish

set normal (set_color normal)
set magenta (set_color magenta)
set yellow (set_color yellow)
set green (set_color green)
set red (set_color red)
set gray (set_color -o black)

set PATH "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" $PATH

function fish_prompt
  set_color $fish_color_cwd
  printf '%s' (prompt_pwd)

  set_color normal
  printf '%s\n' (__fish_git_prompt)

  set_color normal
  printf '%s' '🔥 '
end
