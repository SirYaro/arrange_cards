#!/bin/bash -x

page=`echo $1|rev|cut -f1 -d";"|rev`; page=`printf "%02d\n" $page`	# wytnij ostatni parametr - numer strony
pliki=`echo $1|rev|cut -d";" -f2-|rev`					# wszystko po 1 parametrze to nazwy plików
pliki="$pliki;"								# ;na koncu aby "cut" nie wymagał zmian w kodzie

X_def=$START_X
X=$X_def
Y=$START_Y
file_no=1

files_in_row=${COLUMN}
rows=${ROW}

for r in `seq 1 $rows`; do
    for i in `seq 1 $files_in_row`; do
	plik=`echo "$pliki"|cut -f${file_no} -d";"`; 
	if [ "$plik" != "" ]; then 
	    echo "Processing file $plik..."
	    cp -f ${plik} /tmp/plik

	    if [ ${ROTATE} -gt 0 ]; then
		    convert +profile "*" -rotate ${ROTATE} /tmp/plik /tmp/plik
	    fi
	    composite +profile "*" -geometry +$X+$Y /tmp/plik /tmp/montage.png /tmp/montage.png;
	fi
	SZER=`identify -format '%w' /tmp/plik`; X=$((X + SZER + GAPX));file_no=$((file_no + 1))
    done
    WYS=`identify -format '%h' /tmp/plik`; Y=$((Y + WYS + GAPY))
    if [ $((r%2)) -eq 0 ];
    then	#nieparzyste
	X=$X_def
	#export files_in_row=${COLUMN}
    else
	SHIFT=$((SZER/2+GAPX/2))
	X=$((X_def+SHIFT))
	#export files_in_row=$((COLUMN-1))
    fi

done

composite +profile "*" -verbose -geometry +0+0 $DATA_DIR/overlays/$FRAME /tmp/montage.png page_${page}_${TIMESTAMP}.png
