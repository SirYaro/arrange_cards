#!/bin/bash

# czytam parametry wywolania
SHORTOPTS="i:o:f:c:r:s:b:d:k:h:w:x:y:g:p:"
LONGOPTS="mx:,my:,help,status,landscape,debug:gap:page:"

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
      --landscape)
            ORIENTATION='L'
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
         DEBUG="$2"
         shift
         ;;
      -k)
         KEEP_TEMPORARY="$2"
         shift
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
      -g|--gap)
         GAP="$2"
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
	usage
	echo "Using default file arrange.txt"
	INPUT="arrange.txt"
	#exit
fi

if [ "$OUTPUT" == "" ];
    then
	echo "Missing parameter -o [filename.pdf]"
	usage
	exit
fi

if [ "$FRAME" == "" ];
    then
	echo "Missing parameter -f [filename.png]"
	show_overlays
	usage
	exit
fi

if [ $COUNT -eq 0 ];
    then
	echo "Unspecified ROW or/and COLUMN parameter -c [columns], -r [rows]"
	re='^[0-9]+$'
	if ! [[ $ROW =~ $re ]] ; then
	   echo "error: ROW is not a number"
	fi
	if ! [[ $COLUMN =~ $re ]] ; then
	   echo "error: COLUMN is not a number"
	fi

	usage
	exit
fi

if [ "$PROCESSING_SCRIPT" == "" ];
    then
	echo "Missing parameter -s [script.sh]"
	show_scripts
	usage
	echo ''
	echo "using \"default.sh\""
	PROCESSING_SCRIPT='default.sh'
fi

#if [ "$BACKGROUND" == "" ];
#    then
#	echo "Missing parameter -b [color]"
#	echo "Using default white"
#	BACKGROUND="FFFFFF"
#fi

if [ "$DEBUG" == "1" ];
    then
	echo "Writing debug to arrange.log."
	rm -f arrange.log
	exec 19>arrange.log
	export BASH_XTRACEFD=19
	set -x
fi

if [ "$KEEP_TEMPORARY" == "" ];
    then
	echo "Missing parameter -k [0|1]"
	KEEP_TEMPORARY=0
fi

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