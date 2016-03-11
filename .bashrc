#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='\[\e[36m\]\u\[\e[39m\]@\[\e[30;1m\]\h \[\e[36;49m\]\W\[\e[0m\]\$ \[\e[0m\]'

# No fancy quotes.  I'm fine with plain-old ASCII for myself.
export LC_ALL="C"

# Set up XDG's configuration home:
export XDG_CONFIG_HOME=$HOME/.config

# Use vim for quick edits from the command line.  
# It's faster, but I'll still use Emacs for "serious" programming. =)
export EDITOR=vim

# Move the history dotfile out of the home directory.
export HISTFILE=~/prj/dotfiles/.bash_history

# And the less-history dotfile:
export LESSHISTFILE=~/prj/dotfiles/.lesshst

# And the X-authority dotfile:
export XAUTHORITY=~/prj/dotfiles/.Xauthority

# Tell GNUPG to use ~/prj/dotfiles as it's home
# so I can move the .gnupg directory out of my home folder
export GNUPGHOME=~/prj/dotfiles

# Automagically make xterm transparent.  
# I thought Xterm didn't support transparency.  :-D
[ -n "$XTERM-VERSION" ] && transset-df -a > /dev/null

# Some aliases:
alias cim='vim'
alias ec='emacsclient'
alias ls='ls --color=auto'
alias la='ls -lA'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias pacman='sudo pacman'
