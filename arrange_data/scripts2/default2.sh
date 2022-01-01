#!/bin/bash -x

X=0
Y=0


for r in $(seq 1 ${ROW}); do
    for c in $(seq 1 ${COLUMN}); do
		((FILE_NUMBER+=1))

		PLIK=${FILES[$FILE_NUMBER]}			# starts from index=1
		
		if [ "${PLIK}" != "" ]; then 
			echo -n "Processing file ${PLIK}..."
			cp -f "${PLIK}" /tmp/plik
			SZER=$(identify -format '%w' /tmp/plik) 
    		WYS=$(identify -format '%h' /tmp/plik)

			source "$ACTION_DIR/rotate.sh"	# rotate image
			source "$ACTION_DIR/mask.sh"	# mask (make transparent) part of the image
			source "$ACTION_DIR/rmimage.sh"	# remove part of the image
			source "$ACTION_DIR/reverse.sh"	# mirroring the image
			source "$ACTION_DIR/resize.sh"	# resize the image

		fi

		source "$ACTION_DIR/addmarkers.sh"	# add cut markers
		source "$ACTION_DIR/showprogress.sh"	# show percentage progress

		composite -verbose  -geometry +$((START_X + X))+$((START_Y + Y)) /tmp/plik /tmp/canvas.png /tmp/canvas.png > /dev/null 2>&1

		X=$((X + SZER + GAPX))
				
		if [ ${FILE_NUMBER} -ge ${ALL_FILES_NUM} ]; then	# finish if img count is >= than max
			break 2
		fi
		echo -en "\n"
    done
    Y=$((Y + WYS + GAPY));
    X=0				# reset x axis
done

echo -en "\nGenerating page.\n"
composite -verbose -geometry +0+0 "${OVERLAY_DIR}"/"${FRAME}" +profile "*" /tmp/canvas.png page_"${PAGE}"_"${TIMESTAMP}".png > /dev/null 2>&1		# ADD OVERLAY
if [ ${REVERSE} -eq 1 ]; then
	convert -flop page_"${PAGE}"_"${TIMESTAMP}".png +profile "*" page_"${PAGE}"_"${TIMESTAMP}".png	#REWERS
fi
rm -f /tmp/canvas.png
