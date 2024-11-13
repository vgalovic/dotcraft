#Bear
if [[ -d $HOME/.Bear ]]; then
    export PATH="$HOME/.Bear/bin:$PATH"
fi

#Starship
if command -v starship &>/dev/null; then
    eval "$(starship init bash)"
fi

#Yazi
if command -v yazi &>/dev/null; then

    function y() {
    	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
    }
fi
#bash-preexec.sh

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh

#atuin
if command -v atuin &>/dev/null; then
    eval "$(atuin init bash)"
fi

if command -v fzf &>/dev/null; then

    # Set up fzf key bindings and fuzzy completion

    eval "$(fzf --bash)"

    export FZF_DEFAULT_OPTS=" \
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
    --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
    --color=selected-bg:#45475a \
    --multi"
fi

# ----- Bat (better cat) -----

if command -v bat &>/dev/null; then
    alias cat="bat"

    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    export MANROFFOPT="-c"
    export MANPAGER="must"
    export MANPAGER="less -R --use-color -Dd+r -Du+b"

    # in your .bashrc/.zshrc/*rc
    help() {
        "$@" --help 2>&1 | bat --plain --language=help
    }
fi

# ---- Zoxide (better cd) ----
if command -v zoxide &>/dev/null; then
    if [[ ${BASH_VERSINFO[0]:-0} -eq 4 && ${BASH_VERSINFO[1]:-0} -ge 4 || ${BASH_VERSINFO[0]:-0} -ge 5 ]] &&
    [[ :"${SHELLOPTS}": =~ :(vi|emacs): && ${TERM} != 'dumb' ]]; then
         # Use `printf '\e[5n'` to redraw line after fzf closes.
        \builtin bind '"\e[0n": redraw-current-line' &>/dev/null

        function __zoxide_z_complete() {
            # Only show completions when the cursor is at the end of the line.
            [[ ${#COMP_WORDS[@]} -eq $((COMP_CWORD + 1)) ]] || return

            # If there is only one argument, use `cd` completions.
            if [[ ${#COMP_WORDS[@]} -eq 2 ]]; then
                 \builtin mapfile -t COMPREPLY < <(
                    \builtin compgen -A directory -- "${COMP_WORDS[-1]}" || \builtin true
                )
            # If there is a space after the last word, use interactive selection.
            elif [[ -z ${COMP_WORDS[-1]} ]] && [[ ${COMP_WORDS[-2]} != "${__zoxide_z_prefix}"?* ]]; then
                 \builtin local result
                # shellcheck disable=SC2312
                result="$(\command zoxide query --exclude "$(__zoxide_pwd)" --interactive -- "${COMP_WORDS[@]:1:${#COMP_WORDS[@]}-2}")" &&
                COMPREPLY=("${__zoxide_z_prefix}${result}/")
                \builtin printf '\e[5n'
            fi
        }

        \builtin complete -F __zoxide_z_complete -o filenames -- cd
        \builtin complete -r cdi &>/dev/null || \builtin true
    fi

    eval "$(zoxide init bash)"
    alias cd="z"
fi
# ---- Eza (better ls) -----
if command -v eza &>/dev/null; then
    alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
    alias la="eza --color=always --long --git --icons=always -a"
fi

# thefuck alias
if command -v thefuck &>/dev/null; then
    eval "$(thefuck --alias tf)"
fi

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

if command -v eza &>/dev/null && command -v fzf &>/dev/null && command -v zoxide &>/dev/null; then
    show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

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
        export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
        ssh)          fzf --preview 'dig {}'                   "$@" ;;
        *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
      esac
    }
fi
