# Only run for interactive bash
[[ $- != *i* ]] && return

# Source shared shell scripts
if [ -d "$HOME/.config/shell/shared" ]; then
  for file in "$HOME/.config/shell/shared"/*.sh; do
    [ -r "$file" ] && source "$file"
  done
fi

# Source bash-specific scripts
if [ -d "$HOME/.config/shell/bash" ]; then
  for file in "$HOME/.config/shell/bash"/*.bash; do
    [ -r "$file" ] && source "$file"
  done
fi
