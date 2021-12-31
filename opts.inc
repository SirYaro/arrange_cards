#!/bin/bash

# czytam parametry wywolania
SHORTOPTS="i:o:f:c:r:s:b:dkh:w:x:y:g:p:m:"
LONGOPTS="mx:,my:,help,list,status,landscape,reverse,debug,keep,gapx:,gapy:,page:,rotate:,rmup:,rmdown:,rmright:,rmleft:,crop,mask:,"

# Execute getopt on the arguments passed to this program, identified by the special character $@
#PARSED_OPTIONS=$(getopt -n "$0" -o $SHORTOPTS --long "$LONGOPTS"  -- "$@")
PARSED_OPTIONS=$(getopt -n "$0" --options $SHORTOPTS --longoptions "$LONGOPTS"  -- "$@")

#Bad arguments, something has gone wrong with the getopt command.
if [ $? -ne 0 ];
then
    exit 1
fi

# A little magic, necessary when using getopt.
eval set -- "$PARSED_OPTIONS"


while true; do
    case $1 in
      --help)
            usage
            exit 0
            ;;
      --list)
            list_files
            exit 0
            ;;
      --landscape)
            ORIENTATION='L'
            ;;
      --reverse)
            REVERSE=1
            ;;
      --keep)
            KEEP_TEMPORARY=1
            ;;
      --page)
            PAGE_SIZE=`tr  '[:lower:]' '[:upper:]' <<< ${2}`
            ;;
      --status)
            show_overlays
            show_scripts
            exit 0
            ;;
      -o)
         OUTPUT="$2"
         shift
         ;;
      -i)
         INPUT="$2"
         shift
         ;;
      -f)
         FRAME="$2"
         shift
         ;;
      -c)
         COLUMN="$2"
         shift
         ;;
      -r)
         ROW="$2"
         shift
         ;;
      -s)
         PROCESSING_SCRIPT="$2"
         shift
         ;;
      -b)
         BACKGROUND="$2 "
         shift
         ;;
      -d|--debug)
	 DEBUG=1
	echo "Writing debug to arrange.log."
	rm -f arrange.log
	exec 19>arrange.log
	export BASH_XTRACEFD=19
	set -x

         #DEBUG="$2"
         #shift
         ;;
      -k)
         KEEP_TEMPORARY=1
         ;;
      -h)
	    HEIGHT="$2"
	    RESIZE=1
	    shift
	    ;;
      -w)
	    WIDTH="$2"
	    RESIZE=1
	    shift
	    ;;
      -p)
	    RESIZE_PERCENT="$2"
	    RESIZE=2
	    shift
	    ;;
      -x)
         START_X="$2"
         shift
         ;;
      -y)
         START_Y="$2"
         shift
         ;;
      --gapx)
	 GAPX="$2"
         shift
         ;;
      --gapy)
         GAPY="$2"
         shift
         ;;
      --rmup)
         RMUP="$2"
         RMIMG=1
         shift
         ;;
      --rmdown)
         RMDOWN="$2"
         RMIMG=1
         shift
         ;;
      --rmright)
         RMRIGHT="$2"
         RMIMG=1
         shift
         ;;
      --rmleft)
         RMLEFT="$2"
         RMIMG=1
         shift
         ;;

      --crop)
         CROPIMG=1
         ;;

      --mask)
         MASK="$2 "
         shift
         ;;

      -m)
	 MARKER="$2"
         shift
         ;;
      --mx)
         MARKER_X="$2"
	 MARKER_ENABLED=1
         shift
         ;;
      --my)
         MARKER_Y="$2"
	 MARKER_ENABLED=1
         shift
         ;;
      --rotate)
	 ROTATE="$2"
	 shift
	 ;;
      --)
         shift
         break
         ;;
      *)
         shift
         break
         ;;
   esac
   shift
done


COUNT=$(($ROW * $COLUMN))
# sprawdzam poprawnosc i ew braki w parametrach
if [ "$INPUT" == "" ];
    then
	echo "Missing parameter -i [filename.txt]"
	echo "Currently only files in a current directory are supported"
	#usage
	echo "Using default file arrange.txt"
	INPUT="arrange.txt"
	#exit
fi

if [ "$OUTPUT" == "" ];
    then
	echo "Missing parameter -o [filename.pdf]. Check --help."
	#usage
	exit
fi

if ([[ $MARKER_X == ?(-)+([0-9]) ]] && [[ $MARKER_Y == ?(-)+([0-9]) ]]);
    then 
    echo -ne ""
else
    echo "Both marker values have to be intiger"
    exit
fi


if [ "$FRAME" == "" ];
    then
	echo "Missing parameter -f [filename.png]. Check --help."
	#show_overlays
	#usage
	exit
fi

if [ $COUNT -eq 0 ];
    then
	echo "Unspecified ROW or/and COLUMN parameter -c [columns], -r [rows]. Check --help."
	re='^[0-9]+$'
	if ! [[ $ROW =~ $re ]] ; then
	   echo "error: ROW is not a number"
	fi
	if ! [[ $COLUMN =~ $re ]] ; then
	   echo "error: COLUMN is not a number"
	fi

	#usage
	exit
fi

if [ "$PROCESSING_SCRIPT" == "" ];
    then
	echo "Missing parameter -s [scriptname.sh]. Check --help."
	#show_scripts
	#usage
	echo ''
	echo "using $DEFAULT_PROCESSING_SCRIPT"
	PROCESSING_SCRIPT="$DEFAULT_PROCESSING_SCRIPT"
fi

#if [ "$BACKGROUND" == "" ];
#    then
#	echo "Missing parameter -b [color]"
#	echo "Using default white"
#	BACKGROUND="FFFFFF"
#fi

#if [ "$DEBUG" == "1" ];
#    then
#	echo "Writing debug to arrange.log."
#	rm -f arrange.log
#	exec 19>arrange.log
#	export BASH_XTRACEFD=19
#	set -x
#fi

#if [ "$HEIGHT" != "" ];
#    then
#	RESIZE=1
#fi

#if [ "$WIDTH" != "" ];
#    then
#	RESIZE=1
#fi

if [ "$GAP" == "" ];
    then
	GAP=$DEFAULT_GAP
fi
