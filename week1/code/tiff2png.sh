#!/bin/bash

if test -f *.tiff; then
    echo "There is a .tiff file. Proceed to convert to png."
    for f in *.tiff;
    do
        echo "Converting $f";
        convert "$f" "$(basename "$f" .tiff).png";
    done
else
    echo "No .tiff file in directory. Terminating process."
fi