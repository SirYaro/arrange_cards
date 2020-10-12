#!/bin/bash -x


page=$(echo $1|rev|cut -f1 -d";"|rev)
pliki=$(echo $1|rev|cut -d";" -f2-|rev)
files_number=$(sed 's/;/ /g'<<<$pliki|wc -w)

file_no=1
X=0
Y=0

files_in_row=${COLUMN}
rows=${ROW}

for r in $(seq 1 ${rows}); do
    for c in $(seq 1 ${files_in_row}); do
	ts=$(date +%s%N) 
	FILE_NUMBER=$((FILE_NUMBER + 1))
	plik=$(echo ${pliki}|cut -f${file_no} -d";"); 
	if [ "${plik}" != "" ]; then 
	    echo -n "Processing file ${plik}..."
	    cp -f ${plik} /tmp/plik

	    if [ ${ROTATE} -gt 0 ]; then
		    convert +profile "*" -rotate ${ROTATE} /tmp/plik /tmp/plik
	    fi

	    if [ ${RMUP} -gt 0 ]; then
		SZER=$(identify -format '%w' /tmp/plik) 
		WYS=$(identify -format '%h' /tmp/plik)
		convert -gravity north -chop 0x${RMUP} /tmp/plik /tmp/plik	#RM TOP
		convert -extent ${SZER}x${WYS} -gravity south -background none /tmp/plik /tmp/plik
	    fi
	    if [ ${RMDOWN} -gt 0 ]; then
		SZER=$(identify -format '%w' /tmp/plik) 
		WYS=$(identify -format '%h' /tmp/plik)
		convert -gravity south -chop 0x${RMUP} /tmp/plik /tmp/plik	#RM TOP
		convert -extent ${SZER}x${WYS} -gravity north -background none /tmp/plik /tmp/plik
	    fi


	    if [ ${RESIZE} -gt 0 ]; then
		if [ $RESIZE -eq 1 ]; then
		    convert -resize ${WIDTH}x${HEIGHT} /tmp/plik /tmp/plik
		elif [ $RESIZE -eq 2 ]; then
		    convert -resize ${RESIZE_PERCENT}% /tmp/plik /tmp/plik
		fi
		
		if [ ${REVERSE} -eq 1 ]; then
		    convert -flop /tmp/plik /tmp/plik		#REWERS
		fi
		
		composite -verbose  -geometry +$((START_X + X))+$((START_Y + Y)) /tmp/plik /tmp/montage.png /tmp/montage.png > /dev/null 2>&1
		SZER=$(identify -format '%w' /tmp/plik) 
		WYS=$(identify -format '%h' /tmp/plik)
		rm -f /tmp/plik
	    else
		if [ ${REVERSE} -eq 1 ]; then
		    convert -flop /tmp/plik /tmp/plik		#REWERS
		fi
	    	composite -verbose  -geometry +$((START_X + X))+$((START_Y + Y)) /tmp/plik /tmp/montage.png /tmp/montage.png > /dev/null 2>&1
		SZER=$(identify -format '%w' ${plik}) 
		WYS=$(identify -format '%h' ${plik})
	    fi
	fi
	#MARKERS
	if [ $MARKER_ENABLED -eq 1 ]; then
	    convert -verbose /tmp/montage.png \
		${DATA_DIR}/imgs/${MARKER} -geometry +$((START_X + X - 25 + MARKER_X))+$((START_Y + Y - 25 + MARKER_Y)) -composite \
		${DATA_DIR}/imgs/${MARKER} -geometry +$((START_X + X - 25 - MARKER_X + SZER))+$((START_Y + Y - 25 + MARKER_Y)) -composite \
		${DATA_DIR}/imgs/${MARKER} -geometry +$((START_X + X - 25 + MARKER_X))+$((START_Y + Y - 25 - MARKER_Y + WYS)) -composite \
		${DATA_DIR}/imgs/${MARKER} -geometry +$((START_X + X - 25 - MARKER_X + SZER))+$((START_Y + Y - 25 - MARKER_Y + WYS)) -composite \
		/tmp/montage.png > /dev/null 2>&1
	fi
	
	X=$((X + SZER + GAPX))
	
	echo -ne "\t$(bc<<<"scale=2;${file_no}/${files_number}*100"|cut -f1 -d'.')%"		# % PROGRESS
	
	file_no=$((file_no + 1))
	if [ $file_no -gt $files_number ]; then	# finish if img count on page is < than max
	    break 2
	fi
	echo -en "\n"
    done
    Y=$((Y + WYS + GAPY));
    X=0				# reset x axis
done

echo -en "\nGenerating pdf page.\n"
composite -verbose -geometry +0+0 ${DATA_DIR}/overlays/${FRAME} +profile "*" /tmp/montage.png page_${page}_${TIMESTAMP}.png > /dev/null 2>&1		# ADD OVERLAY
if [ ${REVERSE} -eq 1 ]; then
	convert -flop page_${page}_${TIMESTAMP}.png +profile "*" page_${page}_${TIMESTAMP}.png	#REWERS
fi
rm -f /tmp/montage.png
