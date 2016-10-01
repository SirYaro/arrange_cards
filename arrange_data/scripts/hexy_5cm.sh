#!/bin/bash

page=`echo $1|rev|cut -f1 -d";"|rev`; page=`printf "%02d\n" $page`	# wytnij ostatni parametr - numer strony
pliki=`echo $1|rev|cut -d";" -f2-|rev`					# wszystko po 1 parametrze to nazwy plików
pliki="$pliki;"								# ;na koncu aby "cut" nie wymagał zmian w kodzie

X_def=80
X=$X_def
Y=180
file_no=1

files_in_row=3
rows=5

for r in `seq 1 $rows`; do
    for i in `seq 1 $files_in_row`; do
	plik=`echo "$pliki"|cut -f${file_no} -d";"`; 
	if [ "$plik" != "" ]; then 
	    echo "Processing file $plik..."
	    convert -resize 200% $plik /tmp/plik
	    composite -geometry +$X+$Y /tmp/plik /tmp/montage.png /tmp/montage.png;
	fi
	SZER=`identify -format '%w' /tmp/plik`; X=$((X + SZER - 3));file_no=$((file_no + 1))
    done
    WYS=`identify -format '%h' /tmp/plik`; Y=$((Y + WYS - 5))
    if [ $((r%2)) -eq 0 ];
    then	#parzyste
	X=$X_def
    else
	SHIFT=$((SZER/2))
	X=$((X_def+SHIFT-1))
    fi


done


composite -verbose -geometry +0+0 $DATA_DIR/$FRAME /tmp/montage.png page_${page}_${TIMESTAMP}.png
