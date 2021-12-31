#!/bin/bash

if [[ ${PLIK} != *"blank"*"png" ]]; then
    if [ "${MASK}" != "" ]; then
        convert  /tmp/plik -background none -flatten +repage \( $DATA_DIR/masks/${MASK} +matte \) -compose CopyOpacity -composite  -gravity center +repage /tmp/plik
    fi
fi