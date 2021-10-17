#!/bin/bash

# bash_profile

# Determine OS and Nix Type
if_os () { [[ $OSTYPE == *$1* ]]; }
if_nix () { 
    case "$OSTYPE" in
        *linux*|*hurd*|*msys*|*cygwin*|*sua*|*interix*) sys="gnu";;
        *bsd*|*darwin*) sys="bsd";;
        *sunos*|*solaris*|*indiana*|*illumos*|*smartos*) sys="sun";;
    esac
    [[ "${sys}" == "$1" ]];
}

# Declare environmental variable $HOME per OS
if_os linux && export HOME='/home/ei9h7'
if_os darwin && export HOME='/Users/ei9h7'
export DOTFILES="$HOME/projects/dotfiles"

# linuxbrew environment
if_os linux && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# bash_paths

# Directories to be prepended to PATH
declare -a dirs_to_prepend=(
    "/usr/local/bin" # Ensure that this bin always takes precedence over `/usr/bin`
    "/usr/local/opt"
    "$HOME/Library/Python/3.8/bin"
    "/opt/homebrew/bin"
    "/usr/local/opt/ruby/bin"
    "/usr/local/lib/ruby/gems/2.7.0/bin"
)

# Directories to be appended to PATH
declare -a dirs_to_append=(
    "/usr/bin"
    "$HOME/bin"
    "$DOTFILES/bin"
    "$(brew --prefix coreutils)/libexec/gnubin" # Add brew-installed GNU core utilities bin
    "$(brew --prefix)/share/npm/bin" # Add npm-installed package bin
)

# Prepend directories to PATH
for index in ${!dirs_to_prepend[*]}
do
    if [ -d ${dirs_to_prepend[$index]} ]; then
        # If these directories exist, then prepend them to existing PATH
        PATH="${dirs_to_prepend[$index]}:$PATH"
    fi
done

# Append directories to PATH
for index in ${!dirs_to_append[*]}
do
    if [ -d ${dirs_to_append[$index]} ]; then
        # If these bins exist, then append them to existing PATH
        PATH="$PATH:${dirs_to_append[$index]}"
    fi
done

unset dirs_to_prepend dirs_to_append

export PATH

source $HOME/.bash_profile.local # Local and private settings not under version control (e.g. git credentials)

# set 256 color profile where possible
if [[ $COLORTERM == gnome-* && $TERM == xterm ]] && infocmp gnome-256color >/dev/null 2>&1; then
    export TERM=gnome-256color
elif infocmp xterm-256color >/dev/null 2>&1; then
    export TERM=xterm-256color
fi

# help compilers find ruby
export LDFLAGS="-L/usr/local/opt/ruby/lib"
export CPPFLAGS="-I/usr/local/opt/ruby/include"

# GRC colorizes nifty unix tools all over the place
# if (( $+commands[grc] )) && (( $+commands[brew] ))
# then
#   source `brew --prefix`/etc/grc.bashrc
# fi

# bash git prompt
  if [ -f /usr/local/opt/bash-git-prompt/share/gitprompt.sh ]; then
    __GIT_PROMPT_DIR=/usr/local/opt/bash-git-prompt/share
    source /usr/local/opt/bash-git-prompt/share/gitprompt.sh; else
    source $DOTFILES/.bash_prompt
  fi

# bash completion
$(brew --prefix)/etc/bash_completion # Bash completion (installed via Homebrew)
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

#silence bash deprecation warning in Catalina
export BASH_SILENCE_DEPRECATION_WARNING=1

# Include alias file (if present) containing aliases for ssh, etc.
if [ -f $DOTFILES/.aliases ]
then
  source $DOTFILES/.aliases
fi

# Include functions file (if present) containing useful functions.
if [ -f $DOTFILES/.functions ]
then
  source $DOTFILES/.functions
fi

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vi'
  else
    if_os darwin && export EDITOR='/Applications/MacVim.app'
    if_os linux && export EDITOR='nvim'
  fi
    # use open source VScode (Codium) on Linux
    if_os linux && alias code='codium'$DOTFILES

# Tell homebrew to not autoupdate every single time I run it (just once a week).
export HOMEBREW_AUTO_UPDATE_SECS=604800

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Check the window size after each command and, if necessary, update the values
# of LINES and COLUMNS.
shopt -s checkwinsize

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Yubikey Agent
#export SSH_AUTH_SOCK="/usr/local/var/run/yubikey-agent.sock"
unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null

# dotfiles git alias
# alias config='git --git-dir="$DOTFILES" --work-tree="$HOME"'

# iterm2 integration
if [ $OSTYPE == darwin ]; then
    test -e "$DOTFILES/.iterm2_shell_integration.bash" && source "$DOTFILES/.iterm2_shell_integration.bash" || true
fi