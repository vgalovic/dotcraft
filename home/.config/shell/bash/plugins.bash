# Starship prompt
eval "$(starship init bash)"

# Television -  general purpose fuzzy finder TUI
eval "$(tv init bash)"

# Bat (Improved cat)
alias cat="bat --plain"

# Help function
help() {
    "$@" --help 2>&1 | bat --plain --language=help
}

# Eza (Improved ls)
alias ls="eza --color=always --icons=always --hyperlink"
alias la="eza --color=always --icons=always --hyperlink --all"
alias ll="eza --color=always --long --git --icons=always --hyperlink --all"
