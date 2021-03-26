#!/bin/bash

file=/tmp/last_active_window
if [[ -s $file ]] ; then
	xdotool windowmap `cat $file`
	cat /dev/null > $file
else 
	wid=`xdotool getactivewindow`
	xdotool windowunmap $wid
	echo $wid > $file
fi
