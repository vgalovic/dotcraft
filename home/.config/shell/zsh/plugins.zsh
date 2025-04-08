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
  # Atuin - Shell history management
  eval "$(atuin init zsh)"

  # Starship - Prompt theme
  eval "$(starship init zsh)"

  # Zoxide - Directory jumping
  eval "$(zoxide init zsh)"
  alias cd="z"

  # Bat - Improved cat with syntax highlighting
  alias cat="bat"
  alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
  alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

  # Eza - Enhanced `ls` replacement
  alias ls="eza --color=always --icons=always --hyperlink"
  alias la="eza --color=always --icons=always --hyperlink --all"
  alias ll="eza --color=always --long --git --icons=always --hyperlink --all"

  # FZF - Command-line fuzzy finder
  eval "$(fzf --zsh)"

  # Catppuccin Theme for FZF
  export FZF_DEFAULT_OPTS=" \
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
  --color=selected-bg:#45475a \
  --multi"

  eval "$(tv init zsh)"
}

# Asynchronous job to load plugins
async_job plugin_load

