#!/bin/sh

dots=$HOME/prj/dotfiles

userresources=$dots/.Xresources
usermodmap=$dots/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap
customkeymap=$dots/xkb/custom-map.xkb

# Merge in the system's defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

# Now integrate the custom keymap.
if [ -f $customkeymap ]; then
    xkbcomp $customkeymap $DISPLAY
fi

# Modify the system's keyboard mapping.
if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

# Load user's X-resources file.
if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

# Modify my keyboard mapping.
if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# Run all the shellscripts in /etc/X11/xinit/xinitrc.d/.
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Stop blinding me at night:
# It turns out that 31.0N, 81.0W is almost exactly outside my building
# in Columbia.
redshift -l31.0:81.0 &

# Start the compositor:
xcompmgr -C &

# Turn off that dumb touchpad:
touchpad disable

# And finally, Start The Awesome.
exec awesome
