#!/bin/bash

DATA_DIR="$MAIN_DIR/arrange_data"
MASK_DIR="$DATA_DIR/masks"
OVERLAY_DIR="$DATA_DIR/overlays"
SCRIPT_DIR="$DATA_DIR/scripts2"
ACTION_DIR="$SCRIPT_DIR/actions"


BACKGROUND="FFFFFF"
COLUMN=0
CROPIMG=0
DEFAULT_GAP=1
DEFAULT_PROCESSING_SCRIPT="default2.sh"
DEPS="convert montage identify csvtool"
FILE_NUMBER=0
FILENAME[0]='0'
FILECOUNT[0]='0'
FILES[0]='0'
KEEP_TEMPORARY=0
MARKER="default.png"
MARKER_ENABLED=0
MARKER_X=0
MARKER_Y=0
ORIENTATION=P
PAGE_SIZE=A4
RESIZE=0
RESIZE=0
RESIZE_PERCENT=0
REVERSE=0
RMDOWN=0
RMIMG=0
RMLEFT=0
RMRIGHT=0
RMUP=0
ROTATE=0
ROW=0
START_X=166
START_Y=166
TIMESTAMP=$(date +%s)