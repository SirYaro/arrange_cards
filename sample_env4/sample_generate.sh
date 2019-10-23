#!/bin/bash

rm *pdf

../arrange.sh -i arrange.txt -o filename.pdf -f gray_frame_thin_cut_port.png -c 2 -r 4 -s mirror.sh -x 50 --mx 36 --my 36 --rotate 90
