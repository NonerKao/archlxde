#!/bin/bash

DISPLAY=":99"
Xvfb $DISPLAY -screen 0 1024x768x24 > /dev/null &
sleep 1
x11vnc -display $DISPLAY -rfbport 5678 -forever -passwdfile VncPassword.txt -q -bg > /dev/null &
sleep 1
#DISPLAY=$DISPLAY G_MESSAGES_DEBUG=all lxpanel --profile LXDE 2>/tmp/lxpanel.err.log >/tmp/lxpanel.out.log &
DISPLAY=$DISPLAY SHELL=/bin/bash lxpanel --profile LXDE 2>/tmp/lxpanel.log &
sleep 1
DISPLAY=$DISPLAY pcmanfm --desktop --profile LXDE 2> /tmp/pcmanfm.log &
sleep 1
DISPLAY=$DISPLAY openbox --config-file /root/.config/openbox/lxde-rc.xml 2>/tmp/openbox.log &
sleep 1
#open sshd
/usr/bin/sshd -D
