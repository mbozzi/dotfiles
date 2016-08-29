# ZSH profile.

if [ -f ~/.zprofile ]; then
   source ~/.zshrc
fi

# Start X at login.
[ -z "$DISPLAY" -a "$(fgconsole)" -eq 1 ] && exec startx
