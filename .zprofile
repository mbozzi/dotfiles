# ZSH profile.

if [ -f ~/.zprofile ]
   source ~/.zprofile
fi

# Start X at login.
[ -z "$DISPLAY" -a "$(fgconsole)" -eq 1 ] && exec startx
