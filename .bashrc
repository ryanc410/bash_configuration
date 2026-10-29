# ~/.bashrc

# 1. Exit immediately if running non-interactively
[[ $- != *i* ]] && return

# 2. Define configuration root
export BASH_CONFIG_DIR="$HOME/.config/bash"

# 3. Define the strict load order (Environment -> Settings -> Behavior)
BASH_MODULES=(
    "env.bash"
    "options.bash"
    "aliases.bash"
    "functions.bash"
    "prompt.bash"
)

# 4. Source core modules
for module in "${BASH_MODULES[@]}"; do
    file="$BASH_CONFIG_DIR/$module"
    if [[ -f "$file" && -r "$file" ]]; then
        # shellcheck source=/dev/null
        source "$file"
    fi
done

# 5. Source machine-specific or private overrides (API keys, work tokens)
if [[ -f "$BASH_CONFIG_DIR/local.bash" && -r "$BASH_CONFIG_DIR/local.bash" ]]; then
    # shellcheck source=/dev/null
    source "$BASH_CONFIG_DIR/local.bash"
fi

# Clean up namespace
unset BASH_MODULES module file
