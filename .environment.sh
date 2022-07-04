#!/bin/bash

# runs in both zsh and bash

export BOOT="$(bootctl -x)"
export BROWSER=firefox
export EDITOR=nvim
export ESP="$(bootctl -p)"
export GIT_PS1_SHOWDIRTYSTATE=auto
export GIT_PS1_SHOWSTASHSTATE=auto
export GIT_PS1_SHOWUNTRACKEDFILES=auto
export GIT_PS1_SHOWUPSTREAM=auto
export GOFLAGS='-trimpath -ldflags=-linkmode=external'
export GPG_TTY="$(tty)"
export LESS='--mouse --wheel-lines=5'
export LESSOPEN="|lesspipe.sh %s"
export MPD_HOST="$XDG_RUNTIME_DIR/mpd/socket"
export NNN_OPTS=r
export NNN_ARCHIVE="\\.(tar|zip|jar|rar|lha|7z|alz|ace|a|ar|arj|arc|rpm|deb|cab|cpio|iso|mtree|xar|warc|t?(gz|grz|bz|bz2|Z|lzma|lzo|lz|lz4|lrz|xz|rz|uu|zst))"
export NNN_FIFO="$XDG_RUNTIME_DIR/nnn.fifo"
export NNN_PLUG='l:nuke;o:fzplug'
export NNN_SSHFS='mount -t sshfs'
export NNN_RCLONE='mount -t rclone -o args2env,vfs-cache-mode=writes'
export PAGER=bat
export PYTHONSTARTUP="$(python3 -m jedi repl)"
export SSH_ASKPASS=/usr/bin/ksshaskpass
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:-/run/user/$UID}/ssh-agent.socket"
export VAGRANT_DEFAULT_PROVIDER=libvirt
export VISUAL=nvim
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

for p in "$HOME/go/bin" "$HOME/.local/bin" "$HOME/bin"; do
	PATH="${PATH//":$p:"/:}"                              # remove from middle
	PATH="${PATH%%":$p"}"                                 # remove from end
	case "$PATH" in "$p:"*) ;; *) PATH="$p:$PATH" ;; esac # prepend if
done
export PATH
