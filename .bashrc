#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Set the prompt string. 
PS1='\[\e[36m\]\u\[\e[39m\]@\[\e[30;1m\]\h \[\e[36;49m\]\W\[\e[0m\]\$ \[\e[0m\]'

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
export GNUPGHOME=~/prj/dotfiles/gnupg

# Move Gimp's profile to the dotfiles folder:
export GIMP2_DIRECTORY=~/prj/dotfiles/gimp-2.8

# Some aliases:
alias cim='vim'
alias ec='emacsclient'
alias ls='ls --color=auto'
alias la='ls -lA'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias pacman='sudo pacman' # because I always forget
alias g='git' # Because those two extra characters are a bitch.

# Shortcuts:
mkcd() { # Make a directory and change to it.
	mkdir $1 && cd $1
}

cdla() { # Change to a directory and print all it's contents.
	cd $1 && la
}

cdls() { # Change to a directory and print some of it's contents.
	cd $1 && ls
}


