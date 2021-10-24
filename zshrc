#!/usr/bin/zsh

# ~/.zshrc: executed by zsh(1) for non-login shells.

# Include .env file to set env variable in advance of any other task, and if doesnt exist to set $DOTFILES as $HOME and set $USER independent of sudo
[ -f "$PWD/projects/dotfiles/.env" ] && source "$PWD/projects/dotfiles/.env" || { export HOME=$PWD && export DOTFILES=$PWD && export USER=`who am i | awk '{print $1}'` ;}

# Include paths file (if present)
[ -f "$DOTFILES/.paths" ] && source "$DOTFILES/.paths"

# Include alias file (if present) containing aliases for ssh, etc.
[ -f "$DOTFILES/.aliases" ] && source "$DOTFILES/.aliases"

# Include functions file (if present) containing useful functions.
[ -f "$DOTFILES/.functions" ] && source "$DOTFILES/.functions"

# Include zsh config (if present)
[ -f "$DOTFILES/zsh/config.zsh" ] && source "$DOTFILES/zsh/config.zsh"
[ -f "$DOTFILES/zsh/fpath.zsh" ] && source "$DOTFILES/zsh/fpath.zsh"

# Prompt
PROMPT="%F{red}┌[%f%F{cyan}%m%f%F{red}]─[%f%F{yellow}%D{%H:%M-%d/%m}%f%F{red}]─[%f%F{magenta}%d%f%F{red}]%f"$'\n'"%F{red}└╼%f%F{green}$USER%f%F{yellow}$%f"

# Nicer prompt.
export PS1=$'\n'"%F{green} %*%F %3~ %F{white}"$'\n'"$ "

# git prompt
[ -f "/usr/local/opt/zsh-git-prompt/zshrc.sh" ] && source "/usr/local/opt/zsh-git-prompt/zshrc.sh"

#####################################################
# Auto completion / suggestion
# Mixing zsh-autocomplete and zsh-autosuggestions
# Requires: zsh-autocomplete (custom packaging by Parrot Team)
# or config submodule add https://github.com/marlonrichert/zsh-autocomplete ~/.zsh/zsh-autocomplete (macOS)
# Jobs: suggest files / foldername / histsory bellow the prompt
# Requires: zsh-autosuggestions (packaging by Debian Team)
# or config submodule add https://github.com/zsh-users/zsh-auto-suggestions ~/.zsh/zsh-autosuggestions (macOS)
# Jobs: Fish-like suggestion for command history
if [ "$OS" == "Linux" ]; then
  [ ! -f "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && sudo apt-get install -y zsh-autosuggestions
  source "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [ ! -f "/usr/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ] && sudo apt-get install -y zsh-autocomplete
  source "/usr/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
fi
if [ "$OS" == "macOS" ]; then
  [ ! -f "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && config submodule add https://github.com/zsh-users/zsh-auto-suggestions $HOME/.zsh/zsh-autosuggestions
  source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
  [ ! -f "$HOME/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ] && config submodule add https://github.com/marlonrichert/zsh-autocomplete $HOME/.zsh/zsh-autocomplete
  source "$HOME/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
fi

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

if [ "$OS" == "Linux" ]; then
  [ ! -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && sudo apt-get install -y zsh-syntax-highlighting
  source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
if [ "$OS" == "macOS" ]; then
  [ ! -f "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && config submodule add https://github.com/zsh-users/zsh-syntax-highlighting $HOME/.zsh/zsh-syntax-highlighting
  source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

autoload -Uz compinit && compinit

# Case insensitive.
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# Uses git's autocompletion for inner commands. Assumes an install of git's
# bash `git-completion` script at $completion below (this is where Homebrew
# tosses it, at least).
completion="$(brew --prefix)/share/zsh/site-functions/_git"

[ -f "$completion" ] && source "$completion"

# Bash-style time output.
export TIMEFMT=$'\nreal\t%*E\nuser\t%*U\nsys\t%*S'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[ -f "$DOTFILES/.p10k.zsh"] && source $DOTFILES/.p10k.zsh

# GPG Agent -- included in .env instead
# export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
# gpgconf --launch gpg-agent

# iTerm2 Shell Integration
[ "$OS" == "macOS" ] && test -e "$DOTFILES/.iterm2_shell_integration.zsh" && source "$DOTFILES/.iterm2_shell_integration.zsh" || true
