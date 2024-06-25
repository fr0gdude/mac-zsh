### Custom prompt ###
RPROMPT="%B%h%b"
function chpwd() {
    if [ "$PWD" = "$HOME" ]; then
        PROMPT="%B%F{red}%1d>%f%b "
    else
        PROMPT="%B%F{red}%d>%f%b "
    fi
}
chpwd

### Use modern completion system ###
autoload -Uz compinit
compinit

### Aliases and functions ###
alias clear='printf "\33c\e[3J"'      # <- More traditional clearing of terminal.
alias clearfetch="clear && fastfetch" # <- Show fastfetch after clearing.
alias rc="sudo reboot"                # <- Fast way to reboot computer.
alias rt="source .zshrc"              # <- Fast way to reload this file.
if [ -n "$(command -v ggrep)" ]; then # <- Change "grep" from BSD grep to GNU grep if it exists.
    alias grep="ggrep"
fi

# Easy search for file names. Either system wide or in current directory.
function lookfor() {
    all=false
    while getopts ':a' opt; do # <- Look for options "-a".
        case "$opt" in
        a)
            all=true # <- Set variable "all" to true if option "-a" is used.
            ;;
        *)
            echo -e "\033[0;31mError:\033[0m Invalid option." >&2
            return 1
            ;;
        esac
    done
    shift "$((OPTIND - 1))"
    if [ -z "$1" ]; then
        echo -e "\033[0;31mError:\033[0m No search term given." >&2
        return 1
    fi
    if [ $all = true ]; then
        find /System -iname $1 -print 2>/dev/null # <- Search system if option "-a" is used.
    else
        find . -iname $1 -print 2>/dev/null
    fi
}

# Easy install. Using Homebrew, search and confirm a package by name.
function install() {
    if [ -z "$1" ]; then
        echo -e "\033[0;31mError:\033[0m No app name given." >&2
        return 1
    fi
    echo "\033[1mAvailable apps containing \"$1\":\033[0m\n"
    brew search $1
    echo "\nConfirm app name:"
    read app_name
    echo
    brew info $app_name
    echo "\nContinue with the install? [Y/n]"
    do=true
    while [ $do = true ]; do # Loop to handle y/n answer.
        read answer
        answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]') # Convert to lowercase.
        if [ -z "$answer" ]; then
            do=false
        elif [ "$answer" = "y" ]; then
            do=false
            echo
        elif [ "$answer" = "n" ]; then
            do=false
            echo "\nAborting."
            return 0
        else
            echo -e "\033[0;31mError:\033[0m Invalid input. Try again:" >&2
        fi
    done
    brew install $app_name
}

# Easy uninstall. Using Homebrew, uninstall/purge files/remove unused dependencies.
function uninstall() {
    if [ -z "$1" ]; then
        echo -e "\033[0;31mError:\033[0m No app name given." >&2
        return 1
    fi
    echo "Searching installed packages...\n"
    list=$(brew list | grep "$1")
    if [ -z "$list" ]; then
        echo "No installed apps containing \"$1\" found."
        return 0
    fi
    echo "\033[1mFound:\033[0m"
    echo $list
    echo "\nConfirm app name:"
    read app_name
    echo
    brew info $app_name
    echo "\nContinue with the uninstall? [Y/n]"
    do=true
    while [ $do = true ]; do # Loop to handle y/n answer.
        read answer
        answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]') # Convert to lowercase.
        if [ -z "$answer" ]; then
            do=false
        elif [ "$answer" = "y" ]; then
            do=false
            echo
        elif [ "$answer" = "n" ]; then
            do=false
            echo "\nAborting."
            return 0
        else
            echo -e "\033[0;31mError:\033[0m Invalid input. Try again:" >&2
        fi
    done
    brew uninstall $app_name --zap
    echo "\nRemoving old dependencies..."
    brew autoremove
}

# Easy update. Using Homebrew, update/upgrade/remove unused dependencies.
function update() {
    brew update
    echo "\nApplying updates..."
    brew upgrade
    echo "\nRemoving old dependencies..."
    brew autoremove
}

clearfetch
