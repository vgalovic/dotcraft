# Starship
eval "$(starship init bash &)"

# Bash Preexec
source ~/.bash-preexec.sh

# Atuin
eval "$(atuin init bash &)"

# FZF
eval "$(fzf --bash &)"  # Lazy load bindings

export FZF_DEFAULT_OPTS="\
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a --multi"

# Bat
alias cat="bat --plain"

help() {
    "$@" --help 2>&1 | bat --plain --language=help
}

# export MANPAGER="sh -c 'col -bx | bat -l man -p'"
# export MANROFFOPT="-c"
# export MANPAGER="must"
# export MANPAGER="less -R --use-color -Dd+r -Du+b"

# Zoxide
eval "$(zoxide init bash &)" && alias cd="z"

# Eza
alias ls="eza --color=always --icons=always --hyperlink"
alias la="eza --color=always --icons=always --hyperlink --all"
alias ll="eza --color=always --long --git --icons=always --hyperlink --all"

# Thefuck
eval "$(thefuck --alias tf &)"

# FZF Advanced Configurations
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

# Advanced customization of fzf options via _fzf_comprun function
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
    local command=$1
    shift
    case "$command" in
        cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
        export|unset) fzf --preview "eval 'echo ${}'" "$@" ;;
        ssh)          fzf --preview 'dig {}' "$@" ;;
        *)            fzf --preview "$preview_cmd" "$@" ;;
    esac
}

alias fzf="fzf --preview '$show_file_or_dir_preview'"
