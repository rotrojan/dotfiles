#!/usr/bin/env sh

# Check if the program is running and runs it if it is not.
function run {
	pgrep -f $1 > /dev/null ;
	if [ $? -ne 0 ] ; then
		$@&
	fi
}

run sxhkd
run picom
run light-locker
run setxkbmap -layout 'us,fr' -variant 'intl,' -option 'grp:shifts_toggle'
run xidlehook --not-when-audio --not-when-fullscreen --timer 150 \
	'light-locker-command -l' ''
run volumeicon
run cbatticon
run blueman-tray
run nm-applet
run udiskie -t
run fbxkb
run /home/bigo/.scripts/time_dwmbar.sh
# redshift does not work when quitting and coming back on dwm. The following
# fixes it.
pgrep -f "redshift.*" > /dev/null && kill $(pgrep -f "redshift.*")
redshift-gtk -l 48.85341:2.3488  
