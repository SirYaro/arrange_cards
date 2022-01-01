#!/bin/bash

rm *pdf

../arrange2.sh -i list.csv -o filename.pdf -f empty.png -c 1 -r 4 -s mirror.sh -x 50 --mx 36 --my 36 --rotate 90 -p 50
