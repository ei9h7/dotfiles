#!usr/bin/zsh

# ~/.zshrc: executed by zsh(1) for non-login shells.

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

# Declare $DOTFILES directory
export DOTFILES="$HOME/projects/dotfiles"

# linuxbrew environment
if_os linux && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# bash_paths

# Directories to be prepended to PATH
declare -a dirs_to_prepend=(
    "/usr/local/bin" #sure that this bin always takes precedence over `/usr/bin`
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

# zsh config
source $DOTFILES/zsh/config.zsh
source $DOTFILES/zsh/fpath.zsh

# help compilers find ruby
export LDFLAGS="-L/usr/local/opt/ruby/lib"
export CPPFLAGS="-I/usr/local/opt/ruby/include"

# Nicer prompt.
export PS1=$'\n'"%F{green} %*%F %3~ %F{white}"$'\n'"$ "

# Prompt
PROMPT="%F{red}┌[%f%F{cyan}%m%f%F{red}]─[%f%F{yellow}%D{%H:%M-%d/%m}%f%F{red}]─[%f%F{magenta}%d%f%F{red}]%f"$'\n'"%F{red}└╼%f%F{green}$USER%f%F{yellow}$%f"

# git prompt
source /usr/local/opt/zsh-git-prompt/zshrc.sh

# another prompt
# source $DOTFILES/zsh/prompt.zsh

#####################################################
# Auto completion / suggestion
# Mixing zsh-autocomplete and zsh-autosuggestions
# Requires: zsh-autocomplete (custom packaging by Parrot Team)
# or config submodule add https://github.com/marlonrichert/zsh-autocomplete ~/.zsh/zsh-autocomplete (macOS)
# Jobs: suggest files / foldername / histsory bellow the prompt
# Requires: zsh-autosuggestions (packaging by Debian Team)
# or config submodule add https://github.com/zsh-users/zsh-auto-suggestions ~/.zsh/zsh-autosuggestions (macOS)
# Jobs: Fish-like suggestion for command history
if [ $OSTYPE == linux-gnu ]; then
    if [ ! -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
        sudo apt-get install zsh-autosuggestions
    fi
    if [ ! -f /usr/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]; then
        sudo apt-get install zsh-autocomplete
    fi
fi
if [ $OSTYPE == darwin ]; then
    if [ ! -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
        config submodule add https://github.com/zsh-users/zsh-auto-suggestions ~/.zsh/zsh-autosuggestions
    fi
    if [ ! -f ~/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh ]; then
        config submodule add https://github.com/marlonrichert/zsh-autocomplete ~/.zsh/zsh-autocomplete
    fi
fi
if_os linux && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh && source /usr/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
if_os darwin && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh && source ~/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# Select all suggestion instead of top on result only
zstyle ':autocomplete:tab:*' insert-unambiguous yes
zstyle ':autocomplete:tab:*' widget-style menu-select
zstyle ':autocomplete:*' min-input 2
bindkey $key[Up] up-line-or-history
bindkey $key[Down] down-line-or-history

##################################################
# Fish like syntax highlighting
# Requires "zsh-syntax-highlighting" from apt
# or config submodule add https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting (macOS)

if [ $OSTYPE == linux-gnu ]; then
    if [ ! -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        sudo apt-get install zsh-syntax-highlighting
    fi
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
if [ $OSTYPE == darwin ]; then
    if [ ! -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        config submodule add https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
    fi
    source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

autoload -Uz compinit && compinit

# Case insensitive.
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# Uses git's autocompletion for inner commands. Assumes an install of git's
# bash `git-completion` script at $completion below (this is where Homebrew
# tosses it, at least).
completion='$(brew --prefix)/share/zsh/site-functions/_git'

if test -f $completion
then
  source $completion
fi

# Bash-style time output.
export TIMEFMT=$'\nreal\t%*E\nuser\t%*U\nsys\t%*S'

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
    if_os linux && alias code='codium'

# Set architecture-specific brew share path.
arch_name="$(uname -m)"
if [ "${arch_name}" = "x86_64" ]; then
    share_path="/usr/local/share"
elif [ "${arch_name}" = "arm64" ]; then
    share_path="/opt/homebrew/share"
else
    echo "Unknown architecture: ${arch_name}"
fi

# Allow Composer to use almost as much RAM as Chrome.
export COMPOSER_MEMORY_LIMIT=-1

# Tell homebrew to not autoupdate every single time I run it (just once a week).
export HOMEBREW_AUTO_UPDATE_SECS=604800

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $DOTFILES/.p10k.zsh ]] || source $DOTFILES/.p10k.zsh

# iTerm2 Shell Integration
if [ $OSTYPE == darwin ]; then
    test -e $DOTFILES/.iterm2_shell_integration.zsh && source $DOTFILES/.iterm2_shell_integration.zsh || true
fi