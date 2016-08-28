# Put automatic configuration options here
zstyle :compinstall filename '/home/mjb/prj/dotfiles/.zshrc_compinstall'

autoload -Uz compinit
compinit

HISTFILE=~/prj/dotfiles/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

# Beeping should be disabled.  I'm pretty sure of this: the kernel has been
# instructed not to load pcspkr, and the speakers have actually been unsoldered
# and removed.  Good luck beeping at me, motherfucker.
unsetopt beep

# Emacs-like keybindings are appreciated.
bindkey -e

PS1="$(tput setaf 6)\u@$(tput setaf 7)\h \W$ $(tput setaf 12)"
export LC_ALL="C"
export XDG_CONFIG_HOME=$HOME/.config
export EDITOR=emacs
export HISTFILE=~/prj/dotfiles/.bash_history
export LESSHISTFILE=~/prj/dotfiles/.lesshst
export XAUTHORITY=~/prj/dotfiles/.Xauthority
export GNUPGHOME=~/prj/dotfiles/gnupg
export GIMP2_DIRECTORY=~/prj/dotfiles/gimp-2.8
export PYTHONSTARTUP=~/prj/dotfiles/python/.pythonrc
export PATH=$PATH:.

# Some aliases:
alias ping='ping -c1'
alias ping-google='ping -c1 8.8.8.8'
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
alias -g cse-server="mbozzi@129.252.130.182"
alias login-to-cse-server="ssh -p 222 mbozzi@129.252.130.182"

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

wifi-on  () {
    # Use rfkill to see if the wifi switch is off.
    rfkill list | grep -qE 'blocked: yes'
    if [ $? -eq 0 ]; then
        printf "warning: Wireless may be blocked.  Check the switch.\n" #
    fi

    sudo netctl start bozzi-2    &
    sudo netctl start uscstudent &
}

wired-on () {
    sudo dhcpcd enp1s0
}

eval $(thefuck --alias)
