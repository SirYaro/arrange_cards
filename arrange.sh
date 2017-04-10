#!/bin/bash

SCRIPT_DIR=`dirname "$(readlink -f "$0")"`
DATA_DIR="$SCRIPT_DIR/arrange_data/"
TIMESTAMP=`date +%s`
ROW=0
COLUMN=0
START_X=166
START_Y=166


source $SCRIPT_DIR/arrange.inc

# czytam parametry wywolania
while getopts i:o:f:c:r:s:b:d:k:h:w:x:y: option
do
    case "${option}"
    in
	o) OUTPUT=${OPTARG};;
	i) INPUT=${OPTARG};;
	f) FRAME=${OPTARG};;
	c) COLUMN=${OPTARG};;
	r) ROW=${OPTARG};;
	s) PROCESSING_SCRIPT=${OPTARG};;
	b) BACKGROUND=${OPTARG};;
	d) DEBUG=${OPTARG};;
	k) KEEP_TEMPORARY=${OPTARG};;
	h) HEIGHT=${OPTARG};;
	w) WIDTH=${OPTARG};;
	x) START_X=${OPTARG};;
	y) START_Y=${OPTARG};;

    esac
done


COUNT=$(($ROW * $COLUMN))
# sprawdzam poprawnosc i ew braki w parametrach
if [ "$INPUT" == "" ];
    then
	echo "Missing parameter -i [filename.txt]"
	echo "Currently only files in a current directory are supported"
	help
	exit
fi

if [ "$OUTPUT" == "" ];
    then
	echo "Missing parameter -o [filename.pdf]"
	help
	exit
fi

if [ "$FRAME" == "" ];
    then
	echo "Missing parameter -f [filename.png]"
	echo "Frames available:"
	ls $DATA_DIR/*png|rev|cut -f1 -d"/"|rev
	help
	exit
fi

if [ $COUNT -eq 0 ];
    then
	echo "Unspecified ROW or/and COLUMN parameter -c [columns], -r [rows]"
	re='^[0-9]+$'
	if ! [[ $ROW =~ $re ]] ; then
	   echo "error: ROW is not a number"
	fi
	if ! [[ $COLUMN =~ $re ]] ; then
	   echo "error: COLUMN is not a number"
	fi

	help
	exit
fi

if [ "$PROCESSING_SCRIPT" == "" ];
    then
	echo "Missing parameter -s [script.sh]"
	echo "Scripts available:"
	ls $DATA_DIR/scripts/*sh|rev|cut -f1 -d"/"|rev
	help
	echo ''
	echo "using \"default.sh\""
	PROCESSING_SCRIPT='default.sh'
fi

if [ "$BACKGROUND" == "" ];
    then
	echo "Missing parameter -b [color]"
	echo "Using default white"
	BACKGROUND="FFFFFF"
fi

if [ "$DEBUG" == "1" ];
    then
	echo "Writing debug to arrange.log."
	rm -f arrange.log
	exec 19>arrange.log
	export BASH_XTRACEFD=19
	set -x
fi

if [ "$KEEP_TEMPORARY" == "" ];
    then
	echo "Missing parameter -k [0|1]"
	KEEP_TEMPORARY=0
fi

if [ "$HEIGHT" != "" ];
    then
	RESIZE=1
fi

if [ "$WIDTH" != "" ];
    then
	RESIZE=1
fi


if [ ! -f $INPUT ]; then
    echo "input file \"$INPUT\" not found!"
    exit 1
fi

BACKGROUND=`tr  '[:lower:]' '[:upper:]' <<< $BACKGROUND`
files_list=""
clean_bg

echo "Populating file list."
readarray data < $INPUT				#plik do macierzy
NUM=`echo "${#data[@]}"`			#ilosc linii w pliku

for linia_nr in `seq 0 $(($NUM-1))`;do

    linia=`echo "${data[linia_nr]}"|xargs`	#trim linijki
    IFS=' ' read -r -a array <<< "$linia"	#explode
    FILE=`echo "${array[0]}"`			#nazwa pliku (path)
    REPEAT=`echo "${array[1]}"`			#ilosc powtórzen
    
    for nr in `seq 1 $REPEAT`; do
	if [ "$files_list" == "" ]; then 		#jak lista pusta nie zrobi ; na początku
		files_list="$FILE"			#budowa listy plików
	else
		files_list="$files_list;$FILE"		#budowa listy plików
	fi
	
    done
done
echo "Populating file list finished."

files_num=`echo $files_list|sed 's/[^;]//g'| wc -c`	#ilosc plików
pages=$(round $files_num)				#ilosc stron do generacji
echo "Creating $pages page(s), max $COUNT images on each page."

start=1;end=$COUNT
for page in `seq 1 $pages`;do
    files=`echo $files_list|cut -f$start-$end -d";"`	#wycinam n-ty set $COUNT grafik
    echo "Processing page $page of $pages."
    merge "${files};${page}"				#generacja grafiki
    clean_bg						#czysci tło
    start=$((start+COUNT))
    end=$((end+COUNT))
done

echo "Generating $OUTPUT file."
convert -units PixelsPerInch -density 300 -define pdf:fit-page=A4 page_*_${TIMESTAMP}.png $OUTPUT
if [ $KEEP_TEMPORARY -eq 0 ]; then
    rm -f page_*_${TIMESTAMP}.png
fi

echo "Done."
