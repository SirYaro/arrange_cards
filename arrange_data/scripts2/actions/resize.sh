#!/bin/bash

if [ ${RESIZE} -gt 0 ]; then
    if [ $RESIZE -eq 1 ]; then
        convert -resize ${WIDTH}x${HEIGHT} /tmp/plik /tmp/plik
    elif [ $RESIZE -eq 2 ]; then
        convert -resize ${RESIZE_PERCENT}% /tmp/plik /tmp/plik
    fi
    
    # if [ ${REVERSE} -eq 1 ]; then
    #     convert -flop /tmp/plik /tmp/plik		#REWERS
    # fi
    
    composite -verbose  -geometry +$((START_X + X))+$((START_Y + Y)) /tmp/plik /tmp/canvas.png /tmp/canvas.png > /dev/null 2>&1
    SZER=$(identify -format '%w' /tmp/plik) 
    WYS=$(identify -format '%h' /tmp/plik)
    rm -f /tmp/plik
# else
#     if [ ${REVERSE} -eq 1 ]; then
#         convert -flop /tmp/plik /tmp/plik		#REWERS
#     fi
#     composite -verbose  -geometry +$((START_X + X))+$((START_Y + Y)) /tmp/plik /tmp/canvas.png /tmp/canvas.png > /dev/null 2>&1
#     SZER=$(identify -format '%w' /tmp/plik) 
#     WYS=$(identify -format '%h' /tmp/plik)
fi