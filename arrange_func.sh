#!/bin/bash



merge(){

page=`echo $1|rev|cut -f1 -d" "|rev`
pliki=`echo $1|rev|cut -d" " -f2-|rev`

plik=`echo $pliki|cut -f1 -d" "`; if [ "$plik" != "" ]; then composite -verbose  -geometry +152+137  $plik /tmp/montage.png /tmp/montage.png;fi
plik=`echo $pliki|cut -f2 -d" "`; if [ "$plik" != "" ]; then composite -verbose  -geometry +896+137  $plik /tmp/montage.png /tmp/montage.png;fi
plik=`echo $pliki|cut -f3 -d" "`; if [ "$plik" != "" ]; then composite -verbose  -geometry +1640+137 $plik /tmp/montage.png /tmp/montage.png;fi
#
plik=`echo $pliki|cut -f4 -d" "`; if [ "$plik" != "" ]; then composite -verbose  -geometry +152+1177  $plik /tmp/montage.png /tmp/montage.png;fi
plik=`echo $pliki|cut -f5 -d" "`; if [ "$plik" != "" ]; then composite -verbose  -geometry +896+1177  $plik /tmp/montage.png /tmp/montage.png;fi
plik=`echo $pliki|cut -f6 -d" "`; if [ "$plik" != "" ]; then composite -verbose  -geometry +1640+1177 $plik /tmp/montage.png /tmp/montage.png;fi
#
plik=`echo $pliki|cut -f7 -d" "`; if [ "$plik" != "" ]; then composite -verbose  -geometry +152+2216  $plik /tmp/montage.png /tmp/montage.png;fi
plik=`echo $pliki|cut -f8 -d" "`; if [ "$plik" != "" ]; then composite -verbose  -geometry +896+2216  $plik /tmp/montage.png /tmp/montage.png;fi
plik=`echo $pliki|cut -f9 -d" "`; if [ "$plik" != "" ]; then composite -verbose  -geometry +1640+2216 $plik /tmp/montage.png /tmp/montage.png;fi

# CHANGE THIS PATH IN NEW ENVIRONMENT !
composite -verbose  -geometry +0+0 /home/yaro/bin/arrange_data/karty_setup_poker.png /tmp/montage.png p$page.png
}

clean_bg()
{
# CHANGE THIS PATH IN NEW ENVIRONMENT !
cp -f /home/yaro/bin/arrange_data/bg.jpg /tmp/montage.png
}

help()
{
    echo "
    -i [filename.txt] input txt filename
    -o [filename.pdf] output pdf filename
    "
}

round()
{
LC_ALL=C printf "%.*f\n" 0 $(echo "scale=2;($1/9)+0.4999" | bc)
};
