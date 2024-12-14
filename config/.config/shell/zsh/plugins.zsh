# File: plugins.zsh

# Asynchronous loading setup
autoload -Uz async
async_init

# Asynchronous plugin initialization
async_start_worker plugin_async

async_job plugin_load() {
    # Atuin - Shell history management
    eval "$(atuin init zsh)"

    eval $(thefuck --alias tf)

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
    alias ls="eza --color=always --long --git --icons=always"
    alias la="eza --color=always --long --git --icons=always -a"

    # FZF - Command-line fuzzy finder
    eval "$(fzf --zsh)"

    # Set FZF options with the preview
    export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
    export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"


    # Catppuccin Theme for FZF
    export FZF_DEFAULT_OPTS=" \
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
        --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
        --color=selected-bg:#45475a \
        --multi"

    # FZF preview configuration with eza and bat
    show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

    # Alias for fzf with eza and bat preview
    alias fzf="fzf --preview '$show_file_or_dir_preview'"

    _fzf_comprun() {
        local command=$1
        shift
        case "$command" in
            cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
            export|unset) fzf --preview "echo ${}" "$@" ;;
            ssh)          fzf --preview 'dig {}' "$@" ;;
            *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
        esac
    }
}

# Asynchronous job to load plugins
async_job plugin_load

