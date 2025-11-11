alias q='exit'
alias ':q'='exit'

alias c='clear'

alias refresh='source ~/.profile; source ~/.config/fish/config.fish'
alias update="$HOME/.config/shell/scripts/update.sh"


alias cat="bat"

alias ls="eza --color=always --icons=always --hyperlink"
alias la="eza --color=always --icons=always --hyperlink --all" 
alias ll="eza --color=always --long --git --icons=always --hyperlink --all"

alias apt-update='sudo apt update'
alias apt-install='sudo apt install -y'
alias apt-upgrade='sudo apt upgrade -y'
alias apt-remove='sudo apt remove -y'
alias apt-purge='sudo apt purge -y'
alias apt-autoremove='sudo apt autoremove -y'

alias weather_vs="curl -s 'wttr.in/Vrbas'"
alias weather_ns="curl -s 'wttr.in/Novi_Sad'"

alias sensors-watch='watch -n1 -d sensors'

alias systemctl_list='systemctl list-unit-files'

# Uncomment and edit path if needed
# alias ts="/home/vgalovic/Applications/TeamSpeak3-Client-linux_amd64/ts3client_runscript.sh"

alias systemc-g="g++ -I $SYSTEMC/include -L$SYSTEMC/lib-linux64 -lsystemc -o"
alias systemc-cl="clang++ -I $SYSTEMC/include -L$SYSTEMC/lib-linux64 -lsystemc -o"

alias vivado_log="rm vivado_*"

# Uncomment if PetaLinux path is valid and you want to run it in Fish
# alias petalinux-setup="source $HOME/Applications/PetaLinux/2023.1/bin/settings.sh"

alias yt-dlp-audio='yt-dlp --extract-audio --audio-format mp3 --audio-quality 0'
alias yt-dlp-audio-playlist='yt-dlp --format bestaudio --extract-audio --audio-format mp3 --audio-quality 160K --output "%(title)s.%(ext)s" --yes-playlist'


alias top="btop"
alias ff="fastfetch"
alias lg="lazygit"
alias lgd="lazygit --path ~/.dotfiles"

alias fzf="fzf --style full --preview 'fzf-preview.sh {}' --bind 'focus:transform-header:file --brief {}'"

alias stow_dotfiles="$HOME/.dotfiles/install/setup/setup_stow.sh"

alias linutil="curl -fsSL https://christitus.com/linux | sh"

alias kittyupdate="curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin"
alias lazygitupdate="$HOME/.dotfiles/install/setup/setup_lazygit.sh"
alias zenupdate='bash -c "(curl https://updates.zen-browser.app/appimage.sh)"'
alias neovimupdate="$HOME/.dotfiles/install/setup/setup_neovim.sh"

alias vi="nvim"
alias vim="nvim"
alias neovide="$HOME/.local/share/AppImage/neovide.appimage"
