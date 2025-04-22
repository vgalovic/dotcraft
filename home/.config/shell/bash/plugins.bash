# Starship prompt
eval "$(starship init bash)"

# Bash Preexec
source ~/.bash-preexec.sh

# Atuin (History manager)
eval "$(atuin init bash)"

# FZF (Fuzzy Finder)
eval "$(fzf --bash)"

# Bat (Improved cat)
alias cat="bat --plain"

# Help function
help() {
    "$@" --help 2>&1 | bat --plain --language=help
}

# Zoxide (cd replacement)
eval "$(zoxide init bash)" && alias cd="z"

# Eza (Improved ls)
alias ls="eza --color=always --icons=always --hyperlink"
alias la="eza --color=always --icons=always --hyperlink --all"
alias ll="eza --color=always --long --git --icons=always --hyperlink --all"

# Thefuck (Fix previous commands)
eval "$(thefuck --alias tf)"

# TV
eval "$(tv init bash)"
