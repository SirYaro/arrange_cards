#!/bin/bash

NAME="filename"

rm -f ${NAME}*.pdf

../arrange.sh -i zetony.txt -o ${NAME}.pdf -f empty.png  -c 12 -r 17 -x 100 -y 100 --gapx 0 --gapy 0 -b fffce9 -m cross_black.png --my 0 --mx 0

