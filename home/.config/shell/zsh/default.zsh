# Default Zsh history behavior
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt append_history             # Append to the history file
setopt inc_append_history         # Write after each command
setopt share_history              # Share history across all sessions
setopt hist_ignore_dups           # Don't record duplicates
setopt hist_ignore_all_dups       # Remove older duplicate entries
setopt hist_reduce_blanks         # Remove superfluous blanks
setopt hist_verify                # Don't execute until you hit enter twice
