#!/bin/bash



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
    -c [count]        files count per page
    -s [filename.sh]  processing script
    -b [RGB color]    background color (ex. -b FFAAC0 )
    -x [1]            enable debug
    "
}

round()
{
LC_ALL=C printf "%.*f\n" 0 $(echo "scale=2;($1/$COUNT)+0.4999" | bc)
};
