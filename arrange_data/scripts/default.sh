#!/bin/bash


page=$(echo $1|rev|cut -f1 -d";"|rev)
pliki=$(echo $1|rev|cut -d";" -f2-|rev)

file_no=1
X=0
Y=0

files_in_row=${COLUMN}
rows=${ROW}

for r in `seq 1 ${rows}`; do
    for c in $(seq 1 ${files_in_row}); do
	plik=$(echo ${pliki}|cut -f${file_no} -d";"); 
	if [ "${plik}" != "" ]; then 
	    echo "Processing file ${plik}..."
	    if [ $RESIZE -eq 1 ]; then
		convert -resize ${WIDTH}x${HEIGHT} $plik /tmp/plik
		composite -verbose  -geometry +$((START_X + X))+$((START_Y + Y))  /tmp/plik /tmp/montage.png /tmp/montage.png;
		SZER=$(identify -format '%w' /tmp/plik) 
		WYS=$(identify -format '%h' /tmp/plik)
	    else
	    	composite -verbose  -geometry +$((START_X + X))+$((START_Y + Y))  ${plik} /tmp/montage.png /tmp/montage.png;
		SZER=$(identify -format '%w' ${plik}) 
		WYS=$(identify -format '%h' ${plik})
	    fi
	fi
	X=$((X + SZER + 1))
	file_no=$((file_no + 1))
    done
    Y=$((Y + WYS + 1));
    X=0				# reset x asix
done


composite -verbose -geometry +0+0 ${DATA_DIR}/${FRAME} /tmp/montage.png page_${page}_${TIMESTAMP}.png
