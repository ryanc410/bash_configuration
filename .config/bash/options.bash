# History retention
export HISTSIZE=100000
export HISTFILESIZE=200000
export HISTCONTROL="ignoreboth"
export HISTIGNORE="ls:ll:cd:exit:pwd:clear:history"
export HISTTIMEFORMAT="%F %T "

# Shell options
shopt -s histappend     # Append to history file on exit, do not overwrite
shopt -s cdspell        # Auto-correct minor cd typos
shopt -s autocd         # Entering a valid path changes directory automatically
shopt -s checkwinsize   # Update LINES and COLUMNS after terminal resize
shopt -s nocaseglob     # Case-insensitive globbing
