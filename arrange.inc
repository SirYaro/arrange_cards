#!/bin/bash


# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
        echo "** Trapped CTRL-C **"
	echo " Exiting"
	exit 0
}


merge(){

source "$DATA_DIR/scripts/$PROCESSING_SCRIPT"

}

clean_bg()
{
echo "Background color set to ${BACKGROUND}."
if [ ! -e "$DATA_DIR/${BACKGROUND}.jpg" ]; then
    convert -units PixelsPerInch -density 300 -size 2480x3508 xc:white "$DATA_DIR/${BACKGROUND}.jpg";convert "$DATA_DIR/${BACKGROUND}.jpg" -fill "#${BACKGROUND}" -colorize 100% "$DATA_DIR/${BACKGROUND}.jpg"
fi
cp -f "$DATA_DIR/${BACKGROUND}.jpg" /tmp/montage.png
}

help()
{
    echo "
    -i [filename.txt] input txt filename
    -o [filename.pdf] output pdf filename
    -f [filename.png] frame filename
    -c [columns]      will arrange object in that many columns
    -r [rows]         will arrange object in that many rows
    -w [width]        resize to width (add ! to enforce ex -w 762!)
    -h [height]       resize to height
    -x [xpixels]      start x coordinates (default 116)
    -y [ypixels]      start x coordinates (default 116)
    -s [filename.sh]  processing script (default default.sh)
    -b [RGB color]    background color (ex. -b FFAAC0 )
    -d [1]            enable debug to arrange.log file
    -k [0|1]          keep temporary files
    "
}

round()
{
LC_ALL=C printf "%.*f\n" 0 $(echo "scale=2;($1/$COUNT)+0.4999" | bc)
};
