#!/bin/bash

# runs in both zsh and bash

export EDITOR=nvim
export VISUAL=nvim

export GIT_PS1_SHOWDIRTYSTATE=auto
export GIT_PS1_SHOWSTASHSTATE=auto
export GIT_PS1_SHOWUNTRACKEDFILES=auto
export GIT_PS1_SHOWUPSTREAM=auto
export GIT_PS1_STATESEPARATOR=
export GIT_PS1_DESCRIBE_STYLE=branch
export GIT_PS1_SHOWCOLORHINTS=auto
export LESS='-R --mouse --wheel-lines=5'
export NNN_OPTS=Br
export NNN_ARCHIVE='\.(tar|zip|jar|rar|lha|7z|alz|ace|a|ar|arj|arc|rpm|deb|cab|cpio|iso|mtree|xar|warc|t?(gz|grz|bz|bz2|Z|lzma|lzo|lz|lz4|lrz|xz|rz|uu|zst))'
export NNN_PLUG='l:nuke;o:fzplug'
export NNN_SSHFS='mount -t sshfs'
export NNN_RCLONE='mount -t rclone -o args2env,vfs-cache-mode=writes'
export NNN_FCOLORS=030304020000060001030501

for p in "$HOME/go/bin" "$HOME/.go/bin" "$HOME/.local/bin" "$HOME/bin"; do
	PATH="${PATH//":$p:"/:}"                              # remove from middle
	PATH="${PATH%%":$p"}"                                 # remove from end
	case "$PATH" in "$p:"*) ;; *) PATH="$p:$PATH" ;; esac # prepend if
done
export PATH
