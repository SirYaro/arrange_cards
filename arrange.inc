#!/bin/bash


# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
        echo "** Trapped CTRL-C **"
	echo " Exiting"
	exit 0
}


function generate(){

source "$DATA_DIR/scripts/$PROCESSING_SCRIPT"

}

function clean_bg()
{
echo "Background color set to ${BACKGROUND}."
BG_FILE_NAME="$DATA_DIR/background/${BACKGROUND}_${PAGE_SIZE}_${ORIENTATION}.jpg"
if [ ! -e "${BG_FILE_NAME}" ]; then
    convert xc:white -page A4 /tmp/myout.pdf										#create empty white pdf
    if [ "${ORIENTATION}" == "L" ]; then 
	convert /tmp/myout.pdf -rotate 90 /tmp/myout.pdf								#rotate it for landscape pages
    fi
    convert -density 300 /tmp/myout.pdf "/tmp/myout.jpg"								#turn into image
    #convert -units PixelsPerInch -density 300 -size 2480x3508 xc:white "$DATA_DIR/${BACKGROUND}.jpg";		
    convert "/tmp/myout.jpg" -fill "#${BACKGROUND}" -colorize 100% "${BG_FILE_NAME}"					# fill with color
fi
cp -f "${BG_FILE_NAME}" /tmp/montage.png
}

function usage()
{
  cat <<EOF | column -s\& -t

    --help & show this output
    -v|--version & show version information
    --status & show available overlays and scripts

    -i [filename.txt] & input txt filename (default arrange.txt)
    -o [filename.pdf] & output pdf filename
    -f [filename.png] & overlay image
    -s [filename.sh] & processing script (default default.sh)

    -c [columns] & will arrange images in that many columns
    -r [rows] & will arrange images in that many rows

    -w [width] & resize to width (add ! to enforce ex -w 762!)
    -h [height] & resize to height
    -p [percent] & resize to given % ratio

    -x [xpixels] & start X coordinates (default 116)
    -y [ypixels] & start X coordinates (default 116)
    -g [pixels] & distance (gap) between images (default 1)

    --mx [pixels] & Add cut marker and shift it inwards image by [pixels] distance on X axis
    --my [pixels] & Add cut marker and shift it inwards image by [pixels] distance on Y axis

    --landscape & Set landscape orientation
    --page [page size] & set page size (default A4)

    -b [RGB color] & background color (ex. -b FFAAC0 )
    -d|--debug [1] & write debug to arrange.log file
    -k [0|1] & keep temporary files

EOF
}

function round()
{
LC_ALL=C printf "%.*f\n" 0 $(echo "scale=2;($1/$COUNT)+0.4999" | bc) #"
};

function show_overlays()
{
	echo "Overlays available:"
	ls $DATA_DIR/overlays/*png|rev|cut -f1 -d"/"|rev
	echo ""
}

function show_scripts()
{
	echo "Scripts available:"
	ls $DATA_DIR/scripts/*sh|rev|cut -f1 -d"/"|rev
	echo ""
}

