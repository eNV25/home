
HISTFILE=~/.zhistory
HISTSIZE=100
SAVEHIST=100
unsetopt beep nomatch
setopt autocd extendedglob combiningchars magicequalsubst
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit

fpath=(~/.zsh/functions/ "${fpath[@]}")

if [[ -s ~/.env ]] source ~/.env
if [[ -s ~/.alias ]] source ~/.alias

autoload -Uz command_not_found_handler
autoload -Uz zmv pick-web-browser run-help
unalias run-help 2>/dev/null 1>/dev/null
unalias 9 2>/dev/null 1>/dev/null
alias help=run-help
alias zmv='zmv'
alias zcp='zmv -c'
alias zln='zmv -l'
alias -s html=pick-web-browser

DISABLE_MAGIC_FUNCTIONS=true

if [[ -s /usr/share/zsh/share/antigen.zsh ]] {
	source /usr/share/zsh/share/antigen.zsh
	antigen use oh-my-zsh
	antigen bundle direnv
	antigen bundle micha/resty
	antigen apply
}

if [[ -s /usr/share/git/completion/git-prompt.sh ]] \
	source /usr/share/git/completion/git-prompt.sh

function prompt {
	if [[ "$PWD" == "/" || "$PWD" == "$HOME" ]]
	then PROMPT=" %~ %# "
	else PROMPT=" %~/ %# "
	fi
	if [[ $NNNLVL -gt 0 ]]; then
		PROMPT="NNNLVL=$NNNLVL$PROMPT"
	elif [[ $SHLVL -gt 1 ]]; then
		PROMPT="SHLVL=$SHLVL$PROMPT"
	fi
}; chpwd_functions+=(prompt); prompt

function rprompt {
	local gitps1="$(__git_ps1 '[%s]')"
	RPROMPT="${gitps1/ /}"
}; precmd_functions+=(rprompt)
