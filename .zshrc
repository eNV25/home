# shellcheck shell=bash

eval "$(/usr/bin/dircolors)"
eval "$(/usr/bin/direnv hook zsh)"

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
	setopt autocd extendedglob combiningchars magicequalsubst

	function _rprompt { RPROMPT="$(__git_ps1 '[%s]') SH${SHLVL}${NNNLVL:+N${NNNLVL}}"; }
	precmd_functions+=(_rprompt)
	PROMPT="%B%F{green}%n@%m%f:%F{blue}%~/%f%#%b "
}

{
	local -A key

	# shellcheck disable=SC2154
	key[Home]="${terminfo[khome]}"
	key[End]="${terminfo[kend]}"
	key[Insert]="${terminfo[kich1]}"
	key[Backspace]="${terminfo[kbs]}"
	key[Delete]="${terminfo[kdch1]}"
	key[Up]="${terminfo[kcuu1]}"
	key[Down]="${terminfo[kcud1]}"
	key[Left]="${terminfo[kcub1]}"
	key[Right]="${terminfo[kcuf1]}"
	key[PageUp]="${terminfo[kpp]}"
	key[PageDown]="${terminfo[knp]}"
	key[ShiftTab]="${terminfo[kcbt]}"

	autoload -Uz history-search-end
	zle -N history-beginning-search-backward-end history-search-end
	zle -N history-beginning-search-forward-end history-search-end

	[[ -n "${key[Home]}" ]] && bindkey -- "${key[Home]}" beginning-of-line
	[[ -n "${key[End]}" ]] && bindkey -- "${key[End]}" end-of-line
	[[ -n "${key[Insert]}" ]] && bindkey -- "${key[Insert]}" overwrite-mode
	[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}" backward-delete-char
	[[ -n "${key[Delete]}" ]] && bindkey -- "${key[Delete]}" delete-char
	[[ -n "${key[Up]}" ]] && bindkey -- "${key[Up]}" history-beginning-search-backward-end    # up-line-or-history
	[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" history-beginning-search-forward-end # down-line-or-history
	[[ -n "${key[Left]}" ]] && bindkey -- "${key[Left]}" backward-char
	[[ -n "${key[Right]}" ]] && bindkey -- "${key[Right]}" forward-char
	[[ -n "${key[PageUp]}" ]] && bindkey -- "${key[PageUp]}" beginning-of-buffer-or-history
	[[ -n "${key[PageDown]}" ]] && bindkey -- "${key[PageDown]}" end-of-buffer-or-history
	[[ -n "${key[ShiftTab]}" ]] && bindkey -- "${key[ShiftTab]}" reverse-menu-complete

	unset key
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

# shellcheck disable=SC2120
function proxy_on {
	export no_proxy="127.0.0.1,::1,localhost,localhost.localdomain,.localhost,.localhost.localdomain"
	local proxy="$1"
	if [[ "$proxy" == "" ]]; then
		echo -n "server: "
		read -r server
		echo -n "port: "
		read -r port
		echo -n "username: "
		read -r username
		if [[ "$username" != "" ]]; then
			echo -n "password: "
			read -res password
			local pre="$username:$password@"
		fi
		proxy="$pre$server:$port"
	fi
	export \
		all_proxy="$proxy" \
		ALL_PROXY="$proxy" \
		http_proxy="$proxy" \
		HTTP_PROXY="$proxy" \
		https_proxy="$proxy" \
		HTTPS_PROXY="$proxy" \
		ftp_proxy="$proxy" \
		FTP_PROXY="$proxy" \
		rsync_proxy="$proxy" \
		RSYNC_PROXY="$proxy"
	echo "Proxy environment variable set." >&2
}

function proxy_off {
	unset all_proxy http_proxy https_proxy ftp_proxy rsync_proxy \
		ALL_PROXY HTTP_PROXY HTTPS_PROXY FTP_PROXY RSYNC_PROXY
	echo "Proxy environment variable removed." >&2
}

function with_proxy { (
	proxy_on
	"$@"
); }

function without_proxy { (
	proxy_off
	"$@"
); }
