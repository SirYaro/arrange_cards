#!/bin/bash -x


# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c()
{
    echo "** Trapped CTRL-C **"
	echo " Exiting"
	exit 0
}

function generate()
{
    source "$DATA_DIR/scripts/$PROCESSING_SCRIPT"
}

function clean_bg()
{
    echo "Background color set to ${BACKGROUND}."
    BG_FILE_NAME="$DATA_DIR/background/${BACKGROUND}_${PAGE_SIZE}_${ORIENTATION}.jpg"
    if [ ! -e "${BG_FILE_NAME}" ]; then
        convert -colorspace sRGB  xc:white -page "${PAGE_SIZE}" /tmp/myout.pdf										#create empty white pdf
        if [ "${ORIENTATION}" == "L" ]; then 
        convert  -colorspace sRGB  /tmp/myout.pdf -rotate 90 /tmp/myout.pdf								            #rotate it for landscape pages
        fi
        convert -colorspace sRGB -density 300 /tmp/myout.pdf "/tmp/myout.jpg"								        #turn into image
        #convert -units PixelsPerInch -density 300 -size 2480x3508 xc:white "$DATA_DIR/${BACKGROUND}.jpg";		
        convert  -colorspace sRGB  "/tmp/myout.jpg" -fill "#${BACKGROUND}" -colorize 100% "${BG_FILE_NAME}"			# fill with color
    fi
    cp -f "${BG_FILE_NAME}" /tmp/montage.png
}

function usage()
{
  cat <<EOF | column -s\& -t
    &
    --help & show this output
    -v|--version & show version information
    --status & show available overlays and scripts
    &
    -i [filename.txt] & input txt filename (default arrange.txt)
    -o [filename.pdf] & output pdf filename
    -f [filename.png] & overlay image
    -s [filename.sh] & processing script (default default.sh, most options works with this script only)
    &
    -c [columns] & will arrange images in that many columns
    -r [rows] & will arrange images in that many rows
    &
    -w [width] & resize to width (add ! to enforce ex -w 762!)
    -h [height] & resize to height
    -p [percent] & resize to given % ratio
    --rotate [degrees] & rotate image
    &
    -x [xpixels] & start X coordinates (default 116)
    -y [ypixels] & start X coordinates (default 116)
    --gapx [pixels] & x axis distance (gap) between images (default 1)
    --gapy [pixels] & y axis distance (gap) between images (default 1)
    &
    -m [markername.png] & use specified marker. Requires --mx and --my to be defined
    --mx [pixels] & Add cut marker and shift it inwards image by [pixels] distance on X axis
    --my [pixels] & Add cut marker and shift it inwards image by [pixels] distance on Y axis
    &
    --landscape & Set landscape orientation
    --page [page size] & set page size (default A4)
    &
    --reverse & arrange items from right to left in order to made matching back side
    &
    --rmup [pixels] & Delete top x pixel lines from the image (doesn't change canvas size if --crop not used)
    --rmdown [pixels] & Delete bottom x pixel lines from the image  (doesn't change canvas size if --crop not used)
    --rmleft [pixels] & Delete left most x pixel lines from the image (doesn't change canvas size if --crop not used)
    --rmright [pixels] & Delete right most x pixel lines from the image  (doesn't change canvas size if --crop not used)
    --crop & Disable canvas size preservation while removing part of image with --rmXXX options
    --mask [filename.png] &  Remove white regions of applied B/W mask
    &
    -b [string] & background color or hex cut pattern (ex. -b FFAAC0, -b hex )
    -d|--debug & write debug to arrange.log file
    -k|--keep & keep temporary files
    --list & list files available for this script
    &
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

function show_markers()
{
	echo "Markers available:"
	ls $DATA_DIR/imgs/*png|rev|cut -f1 -d"/"|rev
	echo ""
}

function show_masks()
{
	echo "Masks available:"
	ls $DATA_DIR/masks/*png|rev|cut -f1 -d"/"|rev
	echo ""
}

function list_files()
{
    show_overlays
    show_scripts
    show_markers
    show_masks
}

function CheckDeps()
{
    for DEP in $DEPS; do
        echo "Looking for ${DEP}..."
        which $DEP >> /dev/null
        if [ $? -eq 1 ]; then
            echo -ne "Missing required dependency: \"$DEP\". Exiting."; exit 1
        fi
    done
}
