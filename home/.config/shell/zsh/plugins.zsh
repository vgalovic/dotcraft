# File: plugins.zsh

# Asynchronous loading setup
autoload -Uz async
async_init

# Set vim mode iz zsh
bindkey -v
export KEYTIMEOUT=1

# Asynchronous plugin initialization
async_start_worker plugin_async

async_job plugin_load() {
  # Starship - Prompt theme
  eval "$(starship init zsh)"

  # Television -  general purpose fuzzy finder TUI
  eval "$(tv init zsh)"

  # Bat - Improved cat with syntax highlighting
  alias cat="bat"
  alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
  alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

  # Eza - Enhanced `ls` replacement
  alias ls="eza --color=always --icons=always --hyperlink"
  alias la="eza --color=always --icons=always --hyperlink --all"
  alias ll="eza --color=always --long --git --icons=always --hyperlink --all"
}

# Asynchronous job to load plugins
async_job plugin_load

