if [ ${ROTATE} -gt 0 ]; then
    convert +profile "*" -rotate ${ROTATE} /tmp/plik /tmp/plik
fi