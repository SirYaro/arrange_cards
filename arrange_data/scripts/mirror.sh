#!/bin/bash -x

echo ""
echo "Input file must provides back and front files alternately."
echo ""

page=$(echo $1|rev|cut -f1 -d";"|rev)
pliki=$(echo $1|rev|cut -d";" -f2-|rev)
files_number=$(sed 's/;/ /g'<<<$pliki|wc -w)

file_no=1
PAGE_W=$(identify -format '%w' /tmp/montage.png) 
PAGE_H=$(identify -format '%h' /tmp/montage.png) 
PAGE_CENTER=$((PAGE_W / 2))
if [ -z "$ROTATE" ]; then
    ROTATE=0
fi

X=0
Y=0

files_in_row=${COLUMN}
rows=${ROW}

composite -verbose  -geometry +$((PAGE_CENTER-25))+$((50)) ${DATA_DIR}/imgs/strokesI.png /tmp/montage.png /tmp/montage.png > /dev/null 2>&1

for r in $(seq 1 ${rows}); do	#row
    for c in $(seq 1 ${files_in_row}); do	#column
	ts=$(date +%s%N) 
	FILE_NUMBER=$((FILE_NUMBER + 1))
	plik=$(echo ${pliki}|cut -f${file_no} -d";"); 
	if [ "${plik}" != "" ]; then 
	    echo -n "Processing file ${plik}..."
	    cp -f ${plik} /tmp/plik		#cp file to tmp location

	    if [ ${ROTATE} -gt 0 ]; then
		if (( $c % 2 )); then
		    convert -rotate ${ROTATE} /tmp/plik /tmp/plik
		else
		    convert -rotate -${ROTATE} /tmp/plik /tmp/plik
		fi
	    fi

	    if [ ${RESIZE} -gt 0 ]; then	#resize section
		if [ $RESIZE -eq 1 ]; then
		    convert -resize ${WIDTH}x${HEIGHT} /tmp/plik /tmp/plik
		elif [ $RESIZE -eq 2 ]; then
		    convert -resize ${RESIZE_PERCENT}% /tmp/plik /tmp/plik
		fi
		
		if [ ${REVERSE} -eq 1 ]; then
		    convert -flop /tmp/plik /tmp/plik		#REWERS
		fi

		SZER=$(identify -format '%w' /tmp/plik) 
		WYS=$(identify -format '%h' /tmp/plik)
		
		if (( $c % 2 )); then
    		    #nieparzysta
		    composite -verbose  -geometry +$((PAGE_CENTER - START_X - X - SZER))+$((START_Y + Y)) /tmp/plik /tmp/montage.png /tmp/montage.png > /dev/null 2>&1
		else
		    #parzysta
		    composite -verbose  -geometry +$((PAGE_CENTER + START_X + X))+$((START_Y + Y)) /tmp/plik /tmp/montage.png /tmp/montage.png > /dev/null 2>&1
		fi

	    else	#no resize section
		if [ ${REVERSE} -eq 1 ]; then
		    convert -flop /tmp/plik /tmp/plik		#REWERS
		fi

		SZER=$(identify -format '%w' /tmp/plik) 
		WYS=$(identify -format '%h'  /tmp/plik)
		
		if (( $c % 2 )); then
    		    #nieparzysta/odd
		    composite -verbose  -geometry +$((PAGE_CENTER - START_X - X - SZER))+$((START_Y + Y)) /tmp/plik /tmp/montage.png /tmp/montage.png > /dev/null 2>&1
		else
		    #parzysta/even
		    composite -verbose  -geometry +$((PAGE_CENTER + START_X + X))+$((START_Y + Y)) /tmp/plik /tmp/montage.png /tmp/montage.png > /dev/null 2>&1
		fi

	    fi
	    rm -f /tmp/plik
	fi
	
	if [ $(( $c % 2)) -eq 0 ]; then		    #parzysta/even
	    #ADD MARKERS
	    if [ $MARKER_ENABLED -eq 1 ]; then
		convert -verbose /tmp/montage.png \
		    ${DATA_DIR}/imgs/${MARKER} -geometry +$((PAGE_CENTER + START_X + X - 25 + MARKER_X))+$((START_Y + Y - 25 + MARKER_Y)) -composite \
		    ${DATA_DIR}/imgs/${MARKER} -geometry +$((PAGE_CENTER + START_X + X - 25 - MARKER_X + SZER))+$((START_Y + Y - 25 + MARKER_Y)) -composite \
		    ${DATA_DIR}/imgs/${MARKER} -geometry +$((PAGE_CENTER + START_X + X - 25 + MARKER_X))+$((START_Y + Y - 25 - MARKER_Y + WYS)) -composite \
		    ${DATA_DIR}/imgs/${MARKER} -geometry +$((PAGE_CENTER + START_X + X - 25 - MARKER_X + SZER))+$((START_Y + Y - 25 - MARKER_Y + WYS)) -composite \
		    /tmp/montage.png > /dev/null 2>&1
	    fi
	
	    X=$((X + SZER + GAP))	#increase only every two images
	fi
	
	echo -ne "\t$(bc<<<"scale=2;${file_no}/${files_number}*100"|cut -f1 -d'.')%"		# % PROGRESS
	
	file_no=$((file_no + 1))
	if [ $file_no -gt $files_number ]; then	# finish if img count on page is < than max
	    break 2
	fi

	echo -en "\n"
    done
    Y=$((Y + WYS + GAP));
    X=0				# reset x axis
done

echo -en "\nGenerating pdf page.\n"
composite -verbose -geometry +0+0 ${DATA_DIR}/overlays/${FRAME} +profile "*" /tmp/montage.png page_${page}_${TIMESTAMP}.png > /dev/null 2>&1		# ADD OVERLAY
if [ ${REVERSE} -eq 1 ]; then
	convert -flop page_${page}_${TIMESTAMP}.png +profile "*" page_${page}_${TIMESTAMP}.png	#REWERS
fi
rm -f /tmp/montage.png
