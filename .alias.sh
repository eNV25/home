
unalias ls 2>/dev/null 1>/dev/null
alias l='ls --color=tty -lah --group-directories-first'
alias ls='ls --color=tty --group-directories-first'
alias ll='ls --color=tty -lh --group-directories-first'
alias dir='dir --color=auto'
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ip='ip --color=auto'
alias nvlc='nvlc --no-color'
alias tree='tree -C'

alias pac=paru
alias podman='sudo podman'
alias pwsh='pwsh -NoLogo'
alias curl='curl -s'
alias usv='SVDIR=~/service sv'
alias sudo='sudo '
alias doas='doas '
alias tsocks='tsocks '
alias echoa='echo '
alias nvimpager='nvimpager -p'
alias cat=bat
alias open=xdg-open
alias pager='$PAGER'
alias r=ranger
alias e='$EDITOR'
alias o='$PAGER'
alias h=head
alias t=tail

alias config='git --git-dir="$HOME/.dotgit/" --work-tree="$HOME"'
alias stream='streamlink -p mpv'

case "$TERM" in
alacritty*)
	alias ssh='TERM=xterm-256color ssh'
	alias vagrant='TERM=xterm-256color vagrant'
	;;
*)
	alias ssh=ssh
	alias vagrant=vagrant
	;;
esac

# vi: ft=sh
