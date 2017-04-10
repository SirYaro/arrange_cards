#!/bin/bash


page=`echo $1|rev|cut -f1 -d";"|rev`
pliki=`echo $1|rev|cut -d";" -f2-|rev`

resize()
{
convert $plik -resize 680x980 $plik
}



plik=`echo $pliki|cut -f1 -d";"`; if [ "$plik" != "" ]; then resize;composite -verbose  -geometry +160+145  $plik /tmp/montage.png /tmp/montage.png;fi
plik=`echo $pliki|cut -f2 -d";"`; if [ "$plik" != "" ]; then resize;composite -verbose  -geometry +904+145  $plik /tmp/montage.png /tmp/montage.png;fi
plik=`echo $pliki|cut -f3 -d";"`; if [ "$plik" != "" ]; then resize;composite -verbose  -geometry +1648+145 $plik /tmp/montage.png /tmp/montage.png;fi
#
plik=`echo $pliki|cut -f4 -d";"`; if [ "$plik" != "" ]; then resize;composite -verbose  -geometry +160+1184  $plik /tmp/montage.png /tmp/montage.png;fi
plik=`echo $pliki|cut -f5 -d";"`; if [ "$plik" != "" ]; then resize;composite -verbose  -geometry +904+1184  $plik /tmp/montage.png /tmp/montage.png;fi
plik=`echo $pliki|cut -f6 -d";"`; if [ "$plik" != "" ]; then resize;composite -verbose  -geometry +1648+1184 $plik /tmp/montage.png /tmp/montage.png;fi
#
plik=`echo $pliki|cut -f7 -d";"`; if [ "$plik" != "" ]; then resize;composite -verbose  -geometry +160+2225  $plik /tmp/montage.png /tmp/montage.png;fi
plik=`echo $pliki|cut -f8 -d";"`; if [ "$plik" != "" ]; then resize;composite -verbose  -geometry +904+2225  $plik /tmp/montage.png /tmp/montage.png;fi
plik=`echo $pliki|cut -f9 -d";"`; if [ "$plik" != "" ]; then resize;composite -verbose  -geometry +1648+2225 $plik /tmp/montage.png /tmp/montage.png;fi


composite -verbose -geometry +0+0 $DATA_DIR/$FRAME /tmp/montage.png page_${page}_${TIMESTAMP}.png
