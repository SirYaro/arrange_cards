#!/bin/bash

echo -ne "\t$(bc<<<"scale=2;${FILE_NUMBER}/${ALL_FILES_NUM}*100"|cut -f1 -d'.')%"		# % PROGRESS