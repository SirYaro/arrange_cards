#!/bin/bash


page=`echo $1|rev|cut -f1 -d";"|rev`
pliki=`echo $1|rev|cut -d";" -f2-|rev`

plik=`echo $pliki|cut -f1 -d";"`; if [ "$plik" != "" ]; then composite -verbose  -geometry +152+137  $plik /tmp/montage.png /tmp/montage.png;fi
plik=`echo $pliki|cut -f2 -d";"`; if [ "$plik" != "" ]; then composite -verbose  -geometry +896+137  $plik /tmp/montage.png /tmp/montage.png;fi
plik=`echo $pliki|cut -f3 -d";"`; if [ "$plik" != "" ]; then composite -verbose  -geometry +1640+137 $plik /tmp/montage.png /tmp/montage.png;fi
#
plik=`echo $pliki|cut -f4 -d";"`; if [ "$plik" != "" ]; then composite -verbose  -geometry +152+1177  $plik /tmp/montage.png /tmp/montage.png;fi
plik=`echo $pliki|cut -f5 -d";"`; if [ "$plik" != "" ]; then composite -verbose  -geometry +896+1177  $plik /tmp/montage.png /tmp/montage.png;fi
plik=`echo $pliki|cut -f6 -d";"`; if [ "$plik" != "" ]; then composite -verbose  -geometry +1640+1177 $plik /tmp/montage.png /tmp/montage.png;fi
#
plik=`echo $pliki|cut -f7 -d";"`; if [ "$plik" != "" ]; then composite -verbose  -geometry +152+2216  $plik /tmp/montage.png /tmp/montage.png;fi
plik=`echo $pliki|cut -f8 -d";"`; if [ "$plik" != "" ]; then composite -verbose  -geometry +896+2216  $plik /tmp/montage.png /tmp/montage.png;fi
plik=`echo $pliki|cut -f9 -d";"`; if [ "$plik" != "" ]; then composite -verbose  -geometry +1640+2216 $plik /tmp/montage.png /tmp/montage.png;fi


composite -verbose -geometry +0+0 $DATA_DIR/$FRAME /tmp/montage.png page_${page}_${TIMESTAMP}.png
