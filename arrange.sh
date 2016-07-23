#!/bin/bash

SCRIPT_DIR=`dirname "$(readlink -f "$0")"`
DATA_DIR="$SCRIPT_DIR/arrange_data/"

source $SCRIPT_DIR/arrange_func.sh

# czytam parametry wywolania
while getopts i:o:f:c:d:b: option
do
    case "${option}"
    in
	o) OUTPUT=${OPTARG};;
	i) INPUT=${OPTARG};;
	f) FRAME=${OPTARG};;
	c) COUNT=${OPTARG};;
	d) PROCESSING_SCRIPT=${OPTARG};;
	b) BACKGROUND=${OPTARG};;
    esac
done


# sprawdzam poprawnosc i ew braki w parametrach
if [ "$INPUT" == "" ];
    then
	echo "Missing parameter -i [filename.txt]"
	echo "Currently only files in a current directory are supported"
	help
	exit
fi

if [ "$OUTPUT" == "" ];
    then
	echo "Missing parameter -o [filename.pdf]"
	help
	exit
fi

if [ "$FRAME" == "" ];
    then
	echo "Missing parameter -f [filename.png]"
	echo "Frames available:"
	ls $DATA_DIR/*png|rev|cut -f1 -d"/"|rev
	help
	exit
fi

if [ "$COUNT" == "" ];
    then
	echo "Missing parameter -c [count]"
	help
	exit
fi

if [ "$PROCESSING_SCRIPT" == "" ];
    then
	echo "Missing parameter -d [filename.sh]"
	echo "Data available:"
	ls $DATA_DIR/scripts/*sh|rev|cut -f1 -d"/"|rev
	help
	exit
fi

if [ "$BACKGROUND" == "" ];
    then
	echo "Missing parameter -b [color]"
	echo "Using default white"
	BACKGROUD="FFFFFF"
fi

if [ ! -f $INPUT ]; then
    echo "input file \"$INPUT\" not found!"
    exit 1
fi




files_list=""
clean_bg

readarray data < $INPUT				#plik do macierzy
NUM=`echo "${#data[@]}"`			#ilosc linii w pliku

for linia_nr in `seq 0 $(($NUM-1))`;do

    linia=`echo "${data[linia_nr]}"|xargs`	#trim linijki
    IFS=' ' read -r -a array <<< "$linia"	#explode
    FILE=`echo "${array[0]}"`			#nazwa pliku (path)
    REPEAT=`echo "${array[1]}"`			#ilosc powtórzen
    
    for nr in `seq 1 $REPEAT`; do
	files_list="$files_list $FILE"		#budowa listy plików
    done
done
files_num=`echo $files_list| wc -w`		#ilosc plików
pages=$(round $files_num)			#ilosc stron do generacji
echo "Creating $pages page(s), max $COUNT images each "

start=1;end=$COUNT
for page in `seq 1 $pages`;do
    files=`echo $files_list|cut -f$start-$end -d" "`	#wycinam n-ty set 9ciu kart
    echo "Processing page $page"
    merge "$files $page"				#generacja grafiki
    clean_bg						#czysci tło
    start=$((start+COUNT))
    end=$((end+COUNT))
done

echo "Generating pdf file"
convert p*png -page a4 $OUTPUT

echo "Done."

