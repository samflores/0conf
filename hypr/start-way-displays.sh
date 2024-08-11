#!/bin/bash

sleep 3 # give Hyprland a moment to set its defaults

[ ! -z "$(pidof way-displays)" ] && way-displays -g || (way-displays > "/tmp/way-displays.${XDG_VTNR}.${USER}.log" 2>&1 &)

eww kill > "/tmp/eww.${XDG_VTNR}.${USER}.log" 2>&1
setsid -f eww open-many bar1 bar2 > "/tmp/eww.${XDG_VTNR}.${USER}.log" 2>&1
