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
# Cached because `ng` takes seconds to start; skipped quietly when the installed
# CLI is unusable, e.g. a global Angular CLI that requires a newer Node than the
# one on PATH.
if command -v ng >/dev/null 2>&1; then
    _ng_completion_cache="$HOME/.cache/ng-completion.bash"
    if [ ! -f "$_ng_completion_cache" ] ||
        [ "$(command -v ng)" -nt "$_ng_completion_cache" ] ||
        [ "$(command -v node)" -nt "$_ng_completion_cache" ]; then
        mkdir -p "$(dirname "$_ng_completion_cache")" 2>/dev/null
        { ng completion script >"$_ng_completion_cache" ||
            : >"$_ng_completion_cache"; } 2>/dev/null
    fi
    [ -s "$_ng_completion_cache" ] && . "$_ng_completion_cache"
    unset _ng_completion_cache
fi
