eval "$(/opt/homebrew/bin/brew shellenv)" # <- Add brew env variables and paths
if [ -d "$HOME/.local/bin" ]; then # <- Add home local bin if it exists
    export PATH="$PATH:$HOME/.local/bin"
fi