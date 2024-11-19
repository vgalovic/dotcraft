alias q='exit'

#--------------------------------------------------------------------------------------

alias apt-install='sudo apt install -y'
alias apt-update='sudo apt update'
alias apt-upgrade='sudo apt upgrade -y'
alias apt-remove='sudo apt remove -y'
alias apt-purge='sudo apt purge -y'
alias apt-autoremove='sudo apt autoremove -y'

#--------------------------------------------------------------------------------------

alias flatpak-install='flatpak install -y'
alias flatpak-update='flatpak update -y'
alias flatpak-remove='flatpak remove -y'
alias flatpak-search='flatpak search'
alias flatpak-list='flatpak list'
alias flatpak-info='flatpak info'
alias flatpak-run='flatpak run'

#--------------------------------------------------------------------------------------

alias brew-install='brew install'
alias brew-update='brew update'
alias brew-upgrade='brew upgrade'
alias brew-remove='brew uninstall'
alias brew-cleanup='brew cleanup'
alias brew-search='brew search'
alias brew-list='brew list'
alias brew-info='brew info'
alias brew-leaves='brew leaves'

alias brew-cask-install='brew install --cask'
alias brew-cask-remove='brew uninstall --cask'
alias brew-cask-list='brew list --cask'
alias brew-cask-info='brew info --cask'

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

alias linutil="curl -fsSL https://christitus.com/linux | sh"

#--------------------------------------------------------------------------------------

alias ani="ani-cli"

