if [[ ! -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]]; then
	print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
	command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
	command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" &&
		print -P "%F{33} %F{34}Installation successful.%f%b" ||
		print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
	zdharma-continuum/zinit-annex-as-monitor \
	zdharma-continuum/zinit-annex-bin-gem-node \
	zdharma-continuum/zinit-annex-patch-dl \
	zdharma-continuum/zinit-annex-rust

zinit snippet /usr/share/nnn/quitcd/quitcd.bash_zsh
zinit snippet /usr/share/git/completion/git-prompt.sh
zinit snippet ~/.environment.sh
zinit snippet ~/.alias

zinit load jeffreytse/zsh-vi-mode

zinit ice svn wait lucid
zinit snippet OMZ::plugins/direnv

fpath=(~/.zsh/functions/ "${fpath[@]}")

eval "$(dircolors)"

HISTFILE=~/.zhistory
HISTSIZE=100
SAVEHIST=100
READNULLCMD="$PAGER"
unsetopt beep nomatch
setopt autocd extendedglob combiningchars magicequalsubst

alias help=run-help
alias zmv='zmv'
alias zcp='zmv -c'
alias zln='zmv -l'
alias -s html=pick-web-browser

autoload -Uz compinit && compinit
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
	RPROMPT="$(__git_ps1 '[%s]')"
	RPROMPT="${RPROMPT/ /} SH${SHLVL}${NNNLVL:+N${NNNLVL}}"
}
precmd_functions+=(rprompt)

function proxy_on {
	export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
	local proxy="$1"
	if [[ "$proxy" == "" ]]; then
		echo -n "server: "
		read server
		echo -n "port: "
		read port
		echo -n "username: "
		read username
		if [[ "$username" != "" ]]; then
			echo -n "password: "
			read -es password
			local pre="$username:$password@"
		fi
		proxy="$pre$server:$port"
	fi
	export all_proxy="$proxy" \
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

function pac { without_proxy paru "$@"; }
compdef pac=paru
