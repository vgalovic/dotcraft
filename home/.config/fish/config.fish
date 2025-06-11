# Set SYSTEMC path
set -gx SYSTEMC /usr/local/systemc
set -gx LD_LIBRARY_PATH /usr/local/systemc/lib $LD_LIBRARY_PATH

# Editor and pager
set -gx EDITOR (which nvim)
set -gx MANPAGER "nvim +Man!"

# Load aliases from ~/.config/fish/aliases.fish
if test -f ~/.config/fish/aliases.fish
    source ~/.config/fish/aliases.fish
end

# Only run interactively
if status is-interactive
  # Starship Prompt
  starship init fish | source

  # Television -  general purpose fuzzy finder TUI
  tv init fish | source

  # Bat
  abbr -a --position anywhere -- --help '--help | bat -plhelp'
  abbr -a --position anywhere -- -h '-h | bat -plhelp'
end

functions --erase fish_greeting
function fish_greeting; end
