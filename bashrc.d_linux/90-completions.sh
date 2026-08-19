# Completions and tool loaders (heavier; keep last)

# bash-completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# gcloud
if [ -f '/home/nbrinson2/Downloads/google-cloud-sdk/path.bash.inc' ]; then
    . '/home/nbrinson2/Downloads/google-cloud-sdk/path.bash.inc'
fi
if [ -f '/home/nbrinson2/Downloads/google-cloud-sdk/completion.bash.inc' ]; then
    . '/home/nbrinson2/Downloads/google-cloud-sdk/completion.bash.inc'
fi

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Angular CLI (optional)
# source <(ng completion script)
