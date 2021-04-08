#!/bin/bash

# Req: ImageMagic 6.8.8-8 +


SCRIPT_DIR=`dirname "$(readlink -f "$0")"`
DATA_DIR="$SCRIPT_DIR/arrange_data/"
TIMESTAMP=`date +%s`
RESIZE=0
ROTATE=0
RMUP=0
RMDOWN=0
RMLEFT=0
RMRIGHT=0
RMIMG=0
CROPIMG=0
REVERSE=0
ROW=0
COLUMN=0
START_X=166
START_Y=166
DEFAULT_GAP=1
MARKER="default.png"
MARKER_X=0
MARKER_Y=0
MARKER_ENABLED=0
FILE_NUMBER=0
ttt=0	#total time taken
PAGE_SIZE=A4
ORIENTATION=P
BACKGROUND="FFFFFF"
RESIZE=0
RESIZE_PERCENT=0

source $SCRIPT_DIR/arrange.inc
source $SCRIPT_DIR/opts.inc
mkdir /tmp/1/


####################################################


if [ ! -f $INPUT ]; then
    echo "input file \"$INPUT\" not found!"
    exit 1
fi

BACKGROUND=$(tr '[:lower:]' '[:upper:]' <<< ${BACKGROUND})
BACKGROUND=$(tr -d ' ' <<< ${BACKGROUND})
files_list=""
clean_bg

echo "Populating file list."
readarray data < $INPUT				#plik do macierzy
NUM=$(echo "${#data[@]}")			#ilosc linii w pliku

for linia_nr in `seq 0 $(($NUM-1))`;do

    linia=$(echo "${data[linia_nr]}"|xargs)	#trim linijki
    IFS=' ' read -r -a array <<< "$linia"	#explode
    FILE=$(echo "${array[0]}")			#nazwa pliku (path)
    REPEAT=$(echo "${array[1]}")			#ilosc powtórzen
    
    for nr in $(seq 1 $REPEAT); do
	if [ "$files_list" == "" ]; then 		#jak lista pusta nie zrobi ; na początku
		files_list="$FILE"			#budowa listy plików
	else
		files_list="$files_list;$FILE"		#budowa listy plików
	fi
	
    done
done
echo "Populating file list finished."

all_files_num=$(echo $files_list|sed 's/[^;]//g'| wc -c)	#ilosc plików
pages=$(round $all_files_num)				#ilosc stron do generacji
echo "Creating $pages page(s), max $COUNT images on each page."

start=1;end=$COUNT
for page in $(seq -w 1 $pages);do
    files=$(echo $files_list|cut -f$start-$end -d";")	#wycinam n-ty set $COUNT grafik
    echo "Processing page ${page} of ${pages}."
    generate "${files};${page}"				#generacja grafiki
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
