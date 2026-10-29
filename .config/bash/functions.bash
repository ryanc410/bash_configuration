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

# ======================== #
# Function to check auth.log for failed
# authentication attempts and block the 
# source IP address
# Usage:
#   block_failed_ssh 
block_failed_ssh() {
    local threshold="${1:-5}"   # Default threshold: 5 failed attempts
    local auth_log=""
    
    # 1. Detect log source (systemd journal vs text log files)
    if [[ -f /var/log/auth.log ]]; then
        auth_log="/var/log/auth.log"          # Debian / Ubuntu
    elif [[ -f /var/log/secure ]]; then
        auth_log="/var/log/secure"            # RHEL / CentOS / AlmaLinux / Rocky
    fi

    echo "[*] Checking for SSH brute-force attempts (threshold: ${threshold} failures)..."

    # 2. Extract failed IPs and attempt counts
    local failed_ips
    if [[ -n "$auth_log" ]]; then
        failed_ips=$(grep -E 'Failed password|authentication failure' "$auth_log" \
            | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' \
            | sort | uniq -c)
    elif command -v journalctl >/dev/null 2>&1; then
        failed_ips=$(journalctl -u ssh -u sshd --no-pager 2>/dev/null \
            | grep -E 'Failed password|authentication failure' \
            | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' \
            | sort | uniq -c)
    else
        echo "[-] Error: Neither auth.log, secure, nor journalctl found." >&2
        return 1
    fi

    if [[ -z "$failed_ips" ]]; then
        echo "[+] No failed login records found."
        return 0
    fi

    # 3. Iterate through results and apply iptables rule
    local blocked_count=0
    while read -r count ip; do
        [[ -z "$ip" ]] && continue

        # Safety check: Prevent blocking localhost / private ranges if desired
        if [[ "$ip" =~ ^127\. ]] || [[ "$ip" == "0.0.0.0" ]]; then
            continue
        fi

        if (( count >= threshold )); then
            # Verify if IP is already blocked in iptables
            if iptables -C INPUT -s "$ip" -j DROP 2>/dev/null; then
                echo "[-] IP $ip already blocked (${count} failed attempts)."
            else
                iptables -I INPUT -s "$ip" -p tcp --dport 22 -j DROP
                echo "[!] Blocked $ip (${count} failed attempts)."
                ((blocked_count++))
            fi
        fi
    done <<< "$failed_ips"

    echo "[+] Done. Newly blocked: ${blocked_count} IP(s)."
}
