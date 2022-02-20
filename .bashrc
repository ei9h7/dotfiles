#!/usr/bin/env bash

# bashrc

[ -n "$PS1" ] && source $HOME/.bash_profile
eval "$(thefuck --alias)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
