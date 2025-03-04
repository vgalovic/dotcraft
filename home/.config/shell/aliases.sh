
alias q='exit'
alias :q='exit'

#--------------------------------------------------------------------------------------

alias c='clear'

#--------------------------------------------------------------------------------------

alias refresh='source ~/.profile && source ~/.zshrc'
alias update="~/.config/shell/scripts/update.sh"

#--------------------------------------------------------------------------------------

alias apt-install='sudo apt install -y'
alias apt-update='sudo apt update'
alias apt-upgrade='sudo apt upgrade -y'
alias apt-remove='sudo apt remove -y'
alias apt-purge='sudo apt purge -y'
alias apt-autoremove='sudo apt autoremove -y'

#--------------------------------------------------------------------------------------

alias weather_vs="curl -s 'wttr.in/Vrbas'"
alias weather_ns="curl -s 'wttr.in/Novi_Sad'"

#--------------------------------------------------------------------------------------

alias sensors-watch=' watch -n1 -d sensors'

#--------------------------------------------------------------------------------------

alias systemctl_list='systemctl list-unit-files'


#alias ts="/home/vgalovic/Applications/TeamSpeak3-Client-linux_amd64/ts3client_runscript.sh"

#--------------------------------------------------------------------------------------

# alias systemc="g++ -I ${SYSTEMC}/include -L${SYSTEMC}/lib-linux64 -lsystemc -o"
alias systemc-g="g++ -I ${SYSTEMC}/include -L${SYSTEMC}/lib-linux64 -lsystemc -o"
alias systemc-cl="clang++ -I ${SYSTEMC}/include -L${SYSTEMC}/lib-linux64 -lsystemc -o"

#--------------------------------------------------------------------------------------

alias vivado_log="rm vivado_*"

#alias petalinux-setup="source $HOME/Applications/PetaLinux/2023.1/bin/settings.sh"

#--------------------------------------------------------------------------------------

alias yt-dlp-audio='yt-dlp --extract-audio --audio-format mp3 --audio-quality 0'
alias yt-dlp-audio-playlist='yt-dlp --format bestaudio --extract-audio --audio-format mp3 --audio-quality 160K --output "%(title)s.%(ext)s" --yes-playlist'

#--------------------------------------------------------------------------------------

alias zen-update="bash <(curl https://updates.zen-browser.app/appimage.sh)"

#--------------------------------------------------------------------------------------

alias top="btop"

#--------------------------------------------------------------------------------------

alias stow_dotfiles="$HOME/.dotfiles/install/setup/setup_stow.sh"
alias yazi_plugin_update="$HOME/.dotfiles/install/setup/setup_yazi_plugin.sh"

#--------------------------------------------------------------------------------------

alias linutil="curl -fsSL https://christitus.com/linux | sh"

#--------------------------------------------------------------------------------------

alias kittyupdate="curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin"

#--------------------------------------------------------------------------------------

alias vi="nvim"
alias vim="nvim"

#--------------------------------------------------------------------------------------
