#!/bin/bash


page=`echo $1|rev|cut -f1 -d" "|rev`
pliki=`echo $1|rev|cut -d" " -f2-|rev`

X_def=166
X=$X_def
Y=139
file_no=1

files_in_row=8
rows=18

for r in `seq 1 $rows`; do
    for i in `seq 1 $files_in_row`; do
	plik=`echo $pliki|cut -f$file_no -d" "`; 
	if [ "$plik" != "" ]; then 
	    echo "Processing file $plik..."
	    convert -resize 55% $plik /tmp/plik
	    convert -flop /tmp/plik /tmp/plik
	    composite -verbose  -geometry +$X+$Y  /tmp/plik /tmp/montage.png /tmp/montage.png;
	fi
	SZER=`identify -format '%w' /tmp/plik`; X=$((X + SZER + 1));file_no=$((file_no + 1))
    done
    WYS=`identify -format '%h' /tmp/plik`; Y=$((Y + WYS + 1));X=$X_def
done


composite -verbose  -geometry +0+0 $DATA_DIR/$FRAME /tmp/montage.png p$page.png
convert -flop p$page.png p$page.png