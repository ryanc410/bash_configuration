#----------------------#
# Add Directories to PATH
#----------------------#
addPath() {
	export PATH="$1:PATH"
}

#----------------------------------#
# Function to Easily View Logfiles
# Usage: checklogs
#----------------------------------#
checklogs() {
    echo "Select a log file to view:"
    echo "1) Syslog (/var/log/syslog)"
    echo "2) Auth log (/var/log/auth.log)"
    echo "3) Kernel log (/var/log/kern.log)"
    echo "4) Apache Access (/var/log/apache2/access.log)"
    echo "5) Apache Error (/var/log/apache2/error.log)"
    echo "6) Nginx Access (/var/log/nginx/access.log)"
    echo "7) Nginx Error (/var/log/nginx/error.log)"
    echo "8) Journalctl (systemd logs)"
    read -p "Enter choice [1-8]: " choice

    case "$choice" in
        1) sudo less /var/log/syslog ;;
        2) sudo less /var/log/auth.log ;;
        3) sudo less /var/log/kern.log ;;
        4) sudo less /var/log/apache2/access.log ;;
        5) sudo less /var/log/apache2/error.log ;;
        6) sudo less /var/log/nginx/access.log ;;
        7) sudo less /var/log/nginx/error.log ;;
        8) sudo journalctl -xe ;;
        *) echo "Invalid choice." ;;
    esac
}

#----------------------#
# Navigate Up Sub Directories
# Usage: up 3
#----------------------#
up() {
  cd "$(printf "%0.s../" $(seq 1 "$1"))" || exit 1;
}

#----------------------#
# Extract Archive
# Usage: extract file.tar.gz
#----------------------#
extract() {
  if [[ -f "$1" ]] ; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar e "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xvf "$1"     ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file!"
  fi
}

#----------------------#
# Search for a Process
# Usage: psg apache2
#----------------------#
psg() {
  ps aux | grep -v grep | grep -i --color=auto "$1"
}

# ======================================= #
# Encrypt a file (creates <filename>.enc)
# ======================================= #
enc-file() {
    if [ -z "$1" ] || [ ! -f "$1" ]; then
        echo "Usage: enc-file <filepath>" >&2
        return 1
    fi
    openssl enc -aes-256-cbc -salt -pbkdf2 -in "$1" -out "$1.enc"
}

# ================================================================ #
# Decrypt a file (removes trailing .enc or creates <filename>.dec)
# ================================================================ #
dec-file() {
    if [ -z "$1" ] || [ ! -f "$1" ]; then
        echo "Usage: dec-file <filepath.enc>" >&2
        return 1
    fi
    local outfile="${1%.enc}"
    [[ "$outfile" == "$1" ]] && outfile="$1.dec"
    openssl enc -d -aes-256-cbc -pbkdf2 -in "$1" -out "$outfile"
}

# ==================================================== #
# Encrypt a file symmetrically (creates <filename>.gpg)
# ==================================================== #
gpg-file() {
    if [ -z "$1" ] || [ ! -f "$1" ]; then
        echo "Usage: enc-gpg-file <filepath>" >&2
        return 1
    fi
    gpg --symmetric --quiet --output "$1.gpg" "$1"
}
# =================== #
# Decrypt a GPG file
# =================== #
dgpg-file() {
    if [ -z "$1" ] || [ ! -f "$1" ]; then
        echo "Usage: dec-gpg-file <filepath.gpg>" >&2
        return 1
    fi
    local outfile="${1%.gpg}"
    [[ "$outfile" == "$1" ]] && outfile="$1.dec"
    gpg --decrypt --quiet --output "$outfile" "$1"
}
