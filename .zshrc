
if [[ -f /usr/share/zsh/scripts/zplug/init.zsh ]] source /usr/share/zsh/scripts/zplug/init.zsh

zplug "jeffreytse/zsh-vi-mode"
zplug "plugins/direnv", from:oh-my-zsh

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

fpath=(~/.zsh/functions/ "${fpath[@]}")

if [[ -f /usr/share/git/completion/git-prompt.sh ]] \
	source /usr/share/git/completion/git-prompt.sh

HISTFILE=~/.zhistory
HISTSIZE=100
SAVEHIST=100
unsetopt beep nomatch
setopt autocd extendedglob combiningchars magicequalsubst

autoload -Uz bashcompinit && bashcompinit
autoload -Uz command_not_found_handler
autoload -Uz zmv pick-web-browser run-help
unalias run-help 2>/dev/null 1>/dev/null
unalias 9 2>/dev/null 1>/dev/null

autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

PROMPT="%B%F{green}%n@%m%f:%F{blue}%~/%f%#%b "

function rprompt {
	RPROMPT="${"$(__git_ps1 '[%s]')"/ /} SH${SHLVL}${NNNLVL:+N${NNNLVL}}"
}; precmd_functions+=(rprompt)

eval "$(/usr/bin/systemctl --user show-environment | /usr/bin/sed 's/^/export /g')"

if [[ -f ~/.environment ]] source ~/.environment
if [[ -f ~/.alias ]] source ~/.alias

alias help=run-help
alias zmv='zmv'
alias zcp='zmv -c'
alias zln='zmv -l'
alias -s html=pick-web-browser

