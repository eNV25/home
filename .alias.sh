unalias ls 2>/dev/null 1>/dev/null
alias ls='ls --color=auto --hyperlink=auto --group-directories-first'
alias l='ls -lah'
alias ll='ls -lh'
alias dir='dir --color=auto'
alias diff='batdiff'
alias grep='batgrep'
alias ip='ip --color=auto'
alias nvlc='nvlc --no-color'
alias tree='tree -C'
alias agrep='agrep --color'

alias pac=paru
alias podman='sudo podman'
alias pwsh='pwsh -NoLogo'
alias curl='curl -s'
alias usv='SVDIR=~/service sv'
alias sudo='sudo '
alias doas='doas '
alias run0='run0 '
alias tsocks='tsocks '
alias echoa='echo '
alias nvimpager='nvimpager -p'
alias cat='bat --paging=never'
alias open=xdg-open

alias config='git --git-dir="$HOME/.dotgit/" --work-tree="$HOME"'

case "$TERM" in
alacritty*)
	alias ssh='TERM=xterm-256color ssh'
	alias vagrant='TERM=xterm-256color vagrant'
	;;
*) ;;
esac

# vi: ft=sh
