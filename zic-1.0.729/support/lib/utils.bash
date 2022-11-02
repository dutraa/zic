# init
#
# Should be called at the beginning of every shell script.
#
# Exits your script if you try to use an uninitialized variable and exits your
# script as soon as any statement fails to prevent errors snowballing into
# serious issues.
#
# Example:
# init
#
init(){
    # Will exit script if we would use an uninitialized variable:
    set -u
    # Will exit script when a simple command (not a control structure) fails:
    set -e
}

# log_info message ...
#
# Writes the given messages in green letters to standard output.
#
# Example:
# log_info "Starting install"
#
log_info(){
    local green=$(tput setaf 2)
    local reset=$(tput sgr0)
    echo -e "${green}$@${reset}"
}

# log_important message ...
#
# Writes the given messages in yellow letters to standard output.
#
# Example:
# log_important "Please complete the following task manually."
#
log_important(){
    local yellow=$(tput setaf 3)
    local reset=$(tput sgr0)
    echo -e "${yellow}$@${reset}"
}

# log_warn message ...
#
# Writes the given messages in red letters to standard output.
#
# Example:
# log_warn "There was a failure."
#
log_warn(){
    local red=$(tput setaf 1)
    local reset=$(tput sgr0)
    echo -e "${red}$@${reset}"
}