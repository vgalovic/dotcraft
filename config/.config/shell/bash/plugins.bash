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

# TV
eval "$(tv init bash &)"
