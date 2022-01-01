#!/bin/bash

if [ ${RMIMG} -eq 1 ]; then

    STR=''

    if [ ${RMUP} -gt 0 ]; then
        STR="${STR} -gravity north -chop 0x${RMUP} "
    fi
    if [ ${RMDOWN} -gt 0 ]; then
        STR="${STR} -gravity south -chop 0x${RMDOWN} "
    fi
    if [ ${RMLEFT} -gt 0 ]; then
        STR="${STR} -gravity west -chop ${RMLEFT}x0 "
    fi
    if [ ${RMRIGHT} -gt 0 ]; then
        STR="${STR} -gravity east -chop ${RMRIGHT}x0 "
    fi
    convert ${STR} /tmp/plik /tmp/plik
    if [ ${CROPIMG} -eq 0 ]; then 
        convert -extent ${SZER}x${WYS} -gravity center -background none /tmp/plik /tmp/plik
    fi
fi