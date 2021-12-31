#!/bin/bash

#	Required:
#
#	ImageMagic 6.8.8-8 +
#	Bash 4.0.0 +
#	csvtool

MAIN_DIR=`dirname "$(readlink -f "$0")"`

source "${MAIN_DIR}/vars.inc"
source "${MAIN_DIR}/arrange.inc"
source "${MAIN_DIR}/opts.inc"
mkdir -p /tmp/1/


####################################################

CheckDeps

if [ ! -f ${INPUT} ]; then
    echo "input file \"$INPUT\" not found!"
    exit 1
fi

BACKGROUND=$(tr '[:lower:]' '[:upper:]' <<< ${BACKGROUND})
BACKGROUND=$(tr -d ' ' <<< ${BACKGROUND})
clean_bg

echo "Populating file list."



NUM=$(awk 'NF' ${INPUT} | wc -l)

for OD_LINII in $(seq 1 $NUM)
do
    FILENAME+=("$(csvtool  -t ';' sub $OD_LINII 1 1 1 ${INPUT})")   #csvtool  -t ';' sub $OD_LINII $OD_KOL $LINIANUM $KOLNUM ${INPUT}
    FILECOUNT+=("$(csvtool  -t ';' sub $OD_LINII 2 1 1 ${INPUT})")  # druga kolumna
    
#    echo FILENAME= ${FILENAME[OD_LINII]}
#    echo FILECOUNT= ${FILECOUNT[OD_LINII]}

    for num in `seq 1 ${FILECOUNT[OD_LINII]}`
    do
	FILES+=(${FILENAME[OD_LINII]})
    done

    ALL_FILES_NUM=${#FILES[@]}
    ((ALL_FILES_NUM-=1))
done

echo "Created list with ${ALL_FILES_NUM} items."

PAGES=$(round ${ALL_FILES_NUM})				        #ilosc stron do generacji
echo "Creating ${PAGES} page(s), max ${COUNT} images on each page."

for PAGE in $(seq -w 1 $PAGES);do
    echo "Processing page ${PAGE} of ${PAGES}."
    source "${SCRIPT_DIR}/${PROCESSING_SCRIPT}"         #generacja strony
    clean_bg						                #czysci tło
done


echo "Writing $OUTPUT file."
convert -colorspace sRGB -density 300 -units PixelsPerInch -define pdf:fit-page=${PAGE_SIZE} "page_*_${TIMESTAMP}.png" "${OUTPUT}"
if [ ${KEEP_TEMPORARY} -eq 0 ]; then
    rm -f page_*_"${TIMESTAMP}".png
fi

echo "Done."