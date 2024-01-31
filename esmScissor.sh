#!/bin/bash

/c/ESP/MF_Brete/admin/sissor.sh
mv Scissorhands_report_*.htm esm.html
cat esm.html | lynx -stdin -dump -width=100 | head -n 200 >> esmPassed.txt
