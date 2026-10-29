# aliases.bash
# Custom aliases for the BASH shell
# Updated: October 25, 2026

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
alias nhosts='cd /etc/nginx/sites-available'
alias phpdir='cd /etc/php/*.*'
alias sshdir='cd /etc/ssh'

# Security
alias genpass="openssl rand --base64 $1"
alias etext='openssl enc -aes-256-cbc -a -salt -pbkdf2'
alias dtext='openssl enc -d -aes-256-cbc -a -pbkdf2'
alias gpg-text='gpg --symmetric --armor --quiet'
alias dgpg-text='gpg --decrypt --quiet'

# Media
# Requires yt-dlp is installed(pip install yt-dlp)
# alias ytdlp="yt-dlp -x --audio-format mp3 $1"

# Script Aliases
#alias phpcs="php $BASH_CONFIG_DIR/scripts/phpcs.phar $1"
#alias phpcbf="php $BASH_CONFIG_DIR/scripts/phpcbf.phar $1"
alias genhash="bash $BASH_CONFIG_DIR/scripts/gen-hash.sh"
alias checklogs=checklogs
