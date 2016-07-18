#!/bin/bash



merge(){

source "$DATA_DIR/coordinates/$PROCESSING_SCRIPT"

}

clean_bg()
{
#cp -f /home/yaro/bin/arrange_data/bg.jpg /tmp/montage.png
cp -f $DATA_DIR/bg.jpg /tmp/montage.png
}

help()
{
    echo "
    -i [filename.txt] input txt filename
    -o [filename.pdf] output pdf filename
    -f [filename.png] frame filename
    -c [count]        files per page count
    -d [filename.sh]  script with files parameters
    "
}

round()
{
LC_ALL=C printf "%.*f\n" 0 $(echo "scale=2;($1/$COUNT)+0.4999" | bc)
};
