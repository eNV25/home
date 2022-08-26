#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source ~/.environment.sh
source ~/.alias.sh
PS1='[\u@\h \W]\$ '
