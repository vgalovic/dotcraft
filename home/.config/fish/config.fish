# Disable greeting messages on start
set -g fish_greeting

# Set fzf theme
fzf_theme oldworld

# Only run interactively
if status is-interactive
  # Starship Prompt
  starship init fish | source

  # Television - general purpose fuzzy finder TUI
  tv init fish | source

  # Bat abbreviations
  abbr -a --position anywhere -- --help '--help | bat -plhelp'
  abbr -a --position anywhere -- -h '-h | bat -plhelp'
end
