alias install='sudo apt install'
alias update='sudo apt update'
alias upgrade='sudo apt upgrade'
alias remove='sudo apt remove'
alias purge='sudo apt purge'
alias autoremove='sudo apt autoremove'

alias uu='sudo apt update && sudo apt upgrade'
alias uua='sudo apt update && sudo apt upgrade && sudo apt autoremove'
alias ui='sudo apt update && sudo apt install'

alias u='printf "apt update" && sudo apt update &&
         printf "apt uupgrade" && sudo apt upgrade -y &&
         printf "apt autoremove" && sudo apt autoremove -y &&
         printf "snap refresh" && snap refresh &&
         printf "flatpak update" && flatpak update -y'

alias uq='printf "apt update" && sudo apt update &&
         printf "apt uupgrade" && sudo apt upgrade -y &&
         printf "apt autoremove" && sudo apt autoremove -y &&
         printf "snap refresh" && snap refresh &&
         printf "flatpak update" && flatpak update -y
         printf "exit" && exit'

alias sensors_w=' watch -n1 -d sensors'

alias systemctl_list='systemctl list-unit-files'

alias q='exit'

#alias ts="/home/vgalovic/Applications/TeamSpeak3-Client-linux_amd64/ts3client_runscript.sh"

#--------------------------------------------------------------------------------------

alias systemc="g++ -I ${SYSTEMC}/include -L${SYSTEMC}/lib-linux64 -lsystemc -o"

#--------------------------------------------------------------------------------------

alias vivado_log="rm vivado_*"

#alias petalinux-setup="source $HOME/Applications/PetaLinux/2023.1/bin/settings.sh"

#--------------------------------------------------------------------------------------

alias yt-dlp-audio='yt-dlp --extract-audio --audio-format mp3 --audio-quality 0'

alias yt-dlp-audio-playlist='yt-dlp --format bestaudio --extract-audio --audio-format mp3 --audio-quality 160K --output "%(title)s.%(ext)s" --yes-playlist'

alias zen-update="bash <(curl https://updates.zen-browser.app/appimage.sh)"

alias top="btop"

alias fastfetch="/home/linuxbrew/.linuxbrew/bin/fastfetch -c ~/.config/fastfetch/extended.jsonc"

alias linutil="curl -fsSL https://christitus.com/linux | sh"
