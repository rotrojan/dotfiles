#!/usr/bin/env sh

while true ; do
	xsetroot -name "$(date | cut -d ' ' -f 1-5)"
	sleep 1
done
