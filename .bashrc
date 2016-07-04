#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Set the prompt string.
PS1='\[\e[36m\]\u\[\e[39m\]@\[\e[30;1m\]\h \[\e[36;49m\]\W\[\e[0m\]\$ \[\e[0m\]'

# Some aliases:
alias cim='vim'
alias ec='emacsclient'
alias ls='ls -h --color=auto'
alias la='ls -lAh'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias pacman='sudo pacman' # because I always forget
alias g='git' # Because those two extra characters are a bitch.
alias cse-server="mbozzi@129.252.130.182"
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

wired-on () { sudo dhcpcd enp1s0; }
