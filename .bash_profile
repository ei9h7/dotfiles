#!/bin/bash

# bash_profile

# Include .env file to set env variable in advance of any other task, and if doesnt exist to set $HOME, $USER, and $DOTFILES
if [ -f "$HOME/projects/dotfiles/.env" ]; then
  source "$HOME/projects/dotfiles/.env"; else
  # export USER variable regardless of sudo
  export USER=$(whoami)
# Determine OS and Nix Type
  case "$OSTYPE" in
    solaris*) export OS="Solaris" ;;
    darwin*)  export OS="macOS" ;;
    linux*)   export OS="Linux" ;;
    bsd*)     export OS="BSD" ;;
    msys*)    export OS="Windows" ;;
    cygwin*)  export OS="Windows" ;;
    *)        export OS="unknown: $OSTYPE" ;;
  esac
  # Declare environmental variable $HOME per OS
  [ "$OS" == "Linux" ] && export HOME="/home/$USER"
  [ "$OS" == "macOS" ] && export HOME="/Users/$USER"
  # Declare $DOTFILES
  [ -d $HOME/projects/dotfiles ] && export DOTFILES="$HOME/projects/dotfiles" || export DOTFILES="$HOME"
fi

# Include paths file (if present)
[ -f "$DOTFILES/.paths" ] && source "$DOTFILES/.paths"

# Include alias file (if present) containing aliases for ssh, etc.
[ -f "$DOTFILES/.aliases" ] && source "$DOTFILES/.aliases"

# Include functions file (if present) containing useful functions.
[ -f "$DOTFILES/.functions" ] && source "$DOTFILES/.functions"

# Local and private settings not under version control (e.g. git credentials) (if present)
[ -f "$HOME/.bash_profile.local" ] && source "$HOME/.bash_profile.local"

# set 256 color profile where possible
if [[ $COLORTERM == gnome-* && $TERM == xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
    export TERM=xterm-256color
fi

# GRC colorizes nifty unix tools all over the place
GRC_ALIASES=true
[ -s "`brew --prefix`/etc/grc.bashrc" ] && source "`brew --prefix`/etc/grc.bashrc"
[ -s "`brew --prefix`/etc/grc.sh" ] && source "`brew --prefix`/etc/grc.sh"
[ -s "/etc/profile.d/grc.sh" ] && source "/etc/grc.sh"

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Check the window size after each command and, if necessary, update the values
# of LINES and COLUMNS.
shopt -s checkwinsize

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Case-insensitive matching
shopt -s nocasematch

# bash prompt
[ -f "/usr/local/opt/bash-git-prompt/share/gitprompt.sh" ] && { __GIT_PROMPT_DIR="/usr/local/opt/bash-git-prompt/share" && source "/usr/local/opt/bash-git-prompt/share/gitprompt.sh" ;} || test -f "$DOTFILES/.bash_prompt" && source "$DOTFILES/.bash_prompt"

# Bash completion (installed via Homebrew)
[ -r "/usr/local/etc/profile.d/bash_completion.sh" ] && source "/usr/local/etc/profile.d/bash_completion.sh"

# Silence bash deprecation warning in Catalina
[ "$OS" == "macOS" ] && export BASH_SILENCE_DEPRECATION_WARNING=1

# GPG Agent -- included in .env instead
# export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
# gpgconf --launch gpg-agent

# iterm2 integration
[ "$OS" == "macOS" ] && test -e "$DOTFILES/.iterm2_shell_integration.bash" && source "$DOTFILES/.iterm2_shell_integration.bash" || true
