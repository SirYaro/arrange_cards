#!/bin/bash

#MARKERS
if [ ${MARKER_ENABLED} -eq 1 ]; then
    convert -verbose /tmp/montage.png \
    ${DATA_DIR}/imgs/${MARKER} -geometry +$((START_X + X - 25 + MARKER_X))+$((START_Y + Y - 25 + MARKER_Y)) -composite \
    ${DATA_DIR}/imgs/${MARKER} -geometry +$((START_X + X - 25 - MARKER_X + SZER))+$((START_Y + Y - 25 + MARKER_Y)) -composite \
    ${DATA_DIR}/imgs/${MARKER} -geometry +$((START_X + X - 25 + MARKER_X))+$((START_Y + Y - 25 - MARKER_Y + WYS)) -composite \
    ${DATA_DIR}/imgs/${MARKER} -geometry +$((START_X + X - 25 - MARKER_X + SZER))+$((START_Y + Y - 25 - MARKER_Y + WYS)) -composite \
    /tmp/montage.png > /dev/null 2>&1
fi
