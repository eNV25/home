# shellcheck shell=bash

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit snippet /usr/share/git/completion/git-prompt.sh
zinit snippet ~/.environment.sh
zinit snippet ~/.alias.sh

zinit load jeffreytse/zsh-vi-mode

fpath=(~/.zsh/functions/ "${fpath[@]}")

# shellcheck disable=SC2034
{
	HISTFILE=~/.zhistory
	HISTSIZE=100
	SAVEHIST=100
	READNULLCMD="$PAGER"
	unsetopt beep nomatch
	setopt autocd extendedglob combiningchars magicequalsubst prompt_subst

	RPROMPT='$(__git_ps1 '\''[%s]'\'')%(2L. SH%L.)'
	PROMPT='%B%F{green}%n@%m%f:%F{blue}%~/%f%#%b '
	if [[ "$TERM_PROGRAM" == 'WezTerm' ]]; then
		PROMPT=$'%{\x1b]0;wezterm\x1b\\%}'"$PROMPT"
	fi
}

autoload -Uz compinit && compinit
autoload -Uz bracketed-paste-magic && zle -N bracketed-paste bracketed-paste-magic
autoload -Uz url-quote-magic && zle -N self-insert url-quote-magic
autoload -Uz command_not_found_handler
autoload -Uz zmv pick-web-browser run-help
unalias run-help 2>/dev/null 1>/dev/null
unalias 9 2>/dev/null 1>/dev/null

alias -s html=pick-web-browser
alias help=run-help
alias zmv='zmv'
alias zcp='zmv -c'
alias zln='zmv -l'

eval "$(/usr/bin/dircolors)"
eval "$(/usr/bin/direnv hook zsh)"
eval "$(/usr/bin/batman --export-env)"
 eval "$(/usr/bin/batpipe)"
