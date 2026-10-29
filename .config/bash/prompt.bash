# Non-printing characters are wrapped in \[ ... \] for line wrapping
GREEN="\[\e[1;32m\]"
BLUE="\[\e[1;34m\]"
RESET="\[\e[0m\]"

export PS1="${GREEN}\u@\h${RESET}:${BLUE}\w${RESET}\$ "

unset GREEN BLUE RESE
T
