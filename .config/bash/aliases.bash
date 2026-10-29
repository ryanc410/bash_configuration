# aliases.bash
# File containing custom aliases to ease the use of BASH

alias s='sudo'
alias c='clear'

# APT Aliases
alias update='sudo apt update && sudo apt upgrade -y'
alias install="sudo apt install $1 -y"
alias remove="sudo apt remove $1"
alias search="sudo apt search $1"
alias clean='sudo apt autoremove -y && sudo apt clean'

# Systemctl Aliases
alias start='sudo systemctl start'
alias restart='sudo systemctl restart'
alias reload='sudo systemctl reload'
alias enable='sudo systemctl enable'
alias stop='sudo systemctl stop'
alias status='sudo systemctl status'

# Find Files
alias grep='grep --color=auto'
alias f='find . -name'

# Networking
alias ports='netstat -tulanp'
alias myip='curl ifconfig.me'

# Directories
alias web='cd /var/www/html'
alias vhosts='cd /etc/apache2/sites-available'
alias phpdir='cd /etc/php/*.*/fpm'
alias sshdir='cd /etc/ssh'

# Security
alias genpass="openssl rand --base64 $1"

# Media
alias ytdlp="yt-dlp -x --audio-format mp3 $1"

#Script Aliases
alias checklogs=checklogs
