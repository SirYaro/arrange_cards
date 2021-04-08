#!/bin/bash

page=`echo $1|rev|cut -f1 -d";"|rev`; page=`printf "%02d\n" $page`	# wytnij ostatni parametr - numer strony
pliki=`echo $1|rev|cut -d";" -f2-|rev`					# wszystko po 1 parametrze to nazwy plików
pliki="$pliki;"								# ;na koncu aby "cut" nie wymagał zmian w kodzie

X=$START_X
#X=$X_def
Y=$START_Y
file_no=1

GAPX=$GAPX

files_in_row=${COLUMN}
rows=${ROW}

for r in `seq 1 $rows`; do
    for i in `seq 1 $files_in_row`; do
	plik=`echo "$pliki"|cut -f${file_no} -d";"`; 
	if [ "$plik" != "" ]; then 
	    echo "Processing file $plik..."
	    cp -f ${plik} /tmp/plik


	    if [[ ${plik} = *"exact"*"png" ]]; then
		convert  /tmp/plik -background none -flatten +repage \( $DATA_DIR/masks/hex_28mm_exact.png +matte \) -compose CopyOpacity -composite  -gravity center +repage /tmp/plik
	    elif [[ ${plik} = *"empty"*"png" ]]; then
		convert  /tmp/plik -background none -flatten +repage \( $DATA_DIR/masks/hex_28mm_empty.png +matte \) -compose CopyOpacity -composite  -gravity center +repage /tmp/plik
	    elif [ "${MASK}" != "" ]; then
	        convert  /tmp/plik -background none -flatten +repage \( $DATA_DIR/masks/${MASK} +matte \) -compose CopyOpacity -composite  -gravity center +repage /tmp/plik
	    fi

	    if [ ${RMIMG} -eq 1 ]; then
		SZER=$(identify -format '%w' /tmp/plik) 
		WYS=$(identify -format '%h' /tmp/plik)
		STR=''

		if [ ${RMUP} -gt 0 ]; then
		    STR="${STR} -gravity north -chop 0x${RMUP} "
		    #convert -extent ${SZER}x${WYS} -gravity south -background none /tmp/plik /tmp/plik
		fi
		if [ ${RMDOWN} -gt 0 ]; then
		    STR="${STR} -gravity south -chop 0x${RMDOWN} "
		    #convert -extent ${SZER}x${WYS} -gravity north -background none /tmp/plik /tmp/plik
		fi
		if [ ${RMLEFT} -gt 0 ]; then
		    STR="${STR} -gravity west -chop ${RMLEFT}x0 "
		    #convert -extent ${SZER}x${WYS} -gravity west -background none /tmp/plik /tmp/plik
		fi
		if [ ${RMRIGHT} -gt 0 ]; then
		    STR="${STR} -gravity east -chop ${RMRIGHT}x0 "
		    #convert -extent ${SZER}x${WYS} -gravity east -background none /tmp/plik /tmp/plik
		fi
		convert ${STR} /tmp/plik /tmp/plik
		if [ ${CROPIMG} -eq 0 ]; then 
		    convert -extent ${SZER}x${WYS} -gravity center -background none /tmp/plik /tmp/plik
		fi
	    fi 

	    if [ ${RESIZE} -gt 0 ]; then
		if [ $RESIZE -eq 1 ]; then
		    convert -resize ${WIDTH}x${HEIGHT} /tmp/plik /tmp/plik
		elif [ $RESIZE -eq 2 ]; then
		    convert -resize ${RESIZE_PERCENT}% /tmp/plik /tmp/plik
		fi
	    fi
	    if [ ${REVERSE} -eq 1 ]; then
		convert -flop /tmp/plik /tmp/plik		#REWERS
	    fi

	    if [ ${ROTATE} -gt 0 ]; then
		    convert +profile "*" -rotate ${ROTATE} /tmp/plik /tmp/plik
	    fi

	    cp /tmp/plik /tmp/1/$(basename ${plik})

	    #composite +profile "*" -geometry +$((START_X + X))+$((START_Y + Y)) /tmp/plik /tmp/montage.png /tmp/montage.png > /dev/null 2>&1
	    composite +profile "*" -geometry +${X}+${Y} /tmp/plik /tmp/montage.png /tmp/montage.png > /dev/null 2>&1
	    SZER=$(identify -format '%w' /tmp/plik) 
	    WYS=$(identify -format '%h' /tmp/plik)


#	    composite +profile "*" -geometry +$X+$Y /tmp/plik /tmp/montage.png /tmp/montage.png;
	fi

#	SZER=$(identify -format '%w' /tmp/plik)
	X=$((X + SZER + GAPX))
	file_no=$((file_no + 1))
    done

    SZER=$(identify -format '%w' /tmp/plik)
    WYS=$(identify -format '%h' /tmp/plik)
    Y=$((Y + WYS + GAPY))
    
    if [ $((r%2)) -eq 0 ];
    then	#nieparzyste
	X=${START_X}
	#export files_in_row=${COLUMN}
    else
	SHIFT=$((SZER/2+GAPX/2))
	#SHIFT=$((518/2+GAPX/2))
	X=$((START_X+SHIFT))
	#export files_in_row=$((COLUMN-1))
    fi

done

composite +profile "*" -verbose -geometry +0+0 $DATA_DIR/overlays/$FRAME /tmp/montage.png page_${page}_${TIMESTAMP}.png
