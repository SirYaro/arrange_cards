#!/bin/bash -x

PAGE_W=$(identify -format '%w' /tmp/canvas.png) 
PAGE_H=$(identify -format '%h' /tmp/canvas.png) 
PAGE_CENTER=$((PAGE_W / 2))
if [ -z "$ROTATE" ]; then
    ROTATE=0
fi

X=0
Y=0

# fold line
composite -verbose -colorspace sRGB -density 300 -geometry +$((PAGE_CENTER-25))+$((50)) "${DATA_DIR}"/imgs/strokesI.png /tmp/canvas.png /tmp/canvas.png > /dev/null 2>&1

for r in $(seq 1 ${ROW}); do			#row
    for c in $(seq 1 ${COLUMN}); do		#column
		((FILE_NUMBER+=1))
		PLIKI=${FILES[$FILE_NUMBER]}

		PLIKL=$(cut -f1 -d'|' <<< "${PLIKI}")
		PLIKP=$(cut -f2 -d'|' <<< "${PLIKI}")

		if [ "${PLIKL}" != "" ]; then 
			echo -n "Processing files ${PLIKL}, ${PLIKP}..."

			cp -f ${PLIKL} /tmp/plikL
			cp -f ${PLIKP} /tmp/plikP

			if [ ${RMIMG} -eq 1 ]; then
				STR=''
				if [ ${RMUP} -gt 0 ]; then
					STR="${STR} -gravity north -chop 0x${RMUP} "
				fi
				if [ ${RMDOWN} -gt 0 ]; then
					STR="${STR} -gravity south -chop 0x${RMDOWN} "
				fi
				if [ ${RMLEFT} -gt 0 ]; then
					STR="${STR} -gravity west -chop ${RMLEFT}x0 "
				fi
				if [ ${RMRIGHT} -gt 0 ]; then
					STR="${STR} -gravity east -chop ${RMRIGHT}x0 "
				fi
				convert ${STR} /tmp/plikL /tmp/plikL
				if [ ${CROPIMG} -eq 0 ]; then 
					SZER=$(identify -format '%w' /tmp/plikL) 
    				WYS=$(identify -format '%h' /tmp/plikL)
					convert -extent ${SZER}x${WYS} -gravity center -background none /tmp/plikL /tmp/plikL
				fi
			fi
			if [ ${RMIMG} -eq 1 ]; then
				STR=''
				if [ ${RMUP} -gt 0 ]; then
					STR="${STR} -gravity north -chop 0x${RMUP} "
				fi
				if [ ${RMDOWN} -gt 0 ]; then
					STR="${STR} -gravity south -chop 0x${RMDOWN} "
				fi
				if [ ${RMLEFT} -gt 0 ]; then
					STR="${STR} -gravity west -chop ${RMLEFT}x0 "
				fi
				if [ ${RMRIGHT} -gt 0 ]; then
					STR="${STR} -gravity east -chop ${RMRIGHT}x0 "
				fi
				convert ${STR} /tmp/plikP /tmp/plikP
				if [ ${CROPIMG} -eq 0 ]; then 
					SZER=$(identify -format '%w' /tmp/plikP)
    				WYS=$(identify -format '%h' /tmp/plikP)
					convert -extent ${SZER}x${WYS} -gravity center -background none /tmp/plikP /tmp/plikP
				fi
			fi

			if [ ${ROTATE} -gt 0 ]; then
				convert +profile "*" -rotate "${ROTATE}" /tmp/plikL /tmp/plikL
			fi
			if [ ${ROTATE} -gt 0 ]; then
				convert +profile "*" -rotate "${ROTATE}" /tmp/plikP /tmp/plikP
			fi

			if [ ${RESIZE} -gt 0 ]; then
				if [ $RESIZE -eq 1 ]; then
					convert -resize ${WIDTH}x${HEIGHT} /tmp/plikL /tmp/plikL
				elif [ $RESIZE -eq 2 ]; then
					convert -resize ${RESIZE_PERCENT}% /tmp/plikL /tmp/plikL
				fi
			fi
			if [ ${RESIZE} -gt 0 ]; then
				if [ $RESIZE -eq 1 ]; then
					convert -resize ${WIDTH}x${HEIGHT} /tmp/plikP /tmp/plikP
				elif [ $RESIZE -eq 2 ]; then
					convert -resize ${RESIZE_PERCENT}% /tmp/plikP /tmp/plikP
				fi
			fi

			if [ ${REVERSE} -eq 1 ]; then
				convert -flop /tmp/plikL /tmp/plikL
			fi
			if [ ${REVERSE} -eq 1 ]; then
				convert -flop /tmp/plikP /tmp/plikP
			fi

			SZER=$(identify -format '%w' /tmp/plikL) 
			WYS=$(identify -format '%h'  /tmp/plikL)
			composite -verbose -colorspace sRGB -density 300 -geometry +$((PAGE_CENTER - START_X - X - SZER))+$((START_Y + Y)) /tmp/plikL /tmp/canvas.png /tmp/canvas.png > /dev/null 2>&1

			SZER=$(identify -format '%w' /tmp/plikP) 
			WYS=$(identify -format '%h'  /tmp/plikP)
			composite -verbose -colorspace sRGB -density 300 -geometry +$((PAGE_CENTER + START_X + X))+$((START_Y + Y)) /tmp/plikP /tmp/canvas.png /tmp/canvas.png > /dev/null 2>&1

			rm -f /tmp/plikL
			rm -f /tmp/plikP
		fi

		if [ ${MARKER_ENABLED} -eq 1 ]; then
			convert -verbose /tmp/canvas.png \
			${DATA_DIR}/imgs/${MARKER} -geometry +$((PAGE_CENTER - START_X - X - SZER - 25 + MARKER_X))+$((START_Y + Y - 25 + MARKER_Y)) -composite \
			${DATA_DIR}/imgs/${MARKER} -geometry +$((PAGE_CENTER - START_X - X        - 25 - MARKER_X))+$((START_Y + Y - 25 + MARKER_Y)) -composite \
			${DATA_DIR}/imgs/${MARKER} -geometry +$((PAGE_CENTER - START_X - X - SZER - 25 + MARKER_X))+$((START_Y + Y - 25 - MARKER_Y + WYS)) -composite \
			${DATA_DIR}/imgs/${MARKER} -geometry +$((PAGE_CENTER - START_X - X        - 25 - MARKER_X))+$((START_Y + Y - 25 - MARKER_Y + WYS)) -composite \
			/tmp/canvas.png > /dev/null 2>&1
		fi
		X=$((X + SZER + GAP))				

		source "$ACTION_DIR/showprogress.sh"	# show percentage progress

		if [ ${FILE_NUMBER} -ge ${ALL_FILES_NUM} ]; then	# finish if img count is >= than max
			break 2
		fi
		echo -en "\n"

    done
    Y=$((Y + WYS + GAP));
    X=0				# reset x axis
done

echo -en "\nGenerating page.\n"

composite -colorspace sRGB -density 300 -verbose -geometry +0+0 "${OVERLAY_DIR}"/"${FRAME}" +profile "*" /tmp/canvas.png page_"${PAGE}"_"${TIMESTAMP}".png > /dev/null 2>&1		# ADD OVERLAY
if [ ${REVERSE} -eq 1 ]; then
	convert -flop page_"${PAGE}"_"${TIMESTAMP}".png +profile "*" page_"${PAGE}"_"${TIMESTAMP}".png	#REWERS
fi
rm -f /tmp/canvas.png
