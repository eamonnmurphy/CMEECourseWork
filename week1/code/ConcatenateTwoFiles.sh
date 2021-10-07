#!/bin/bash

cat $1 > $3
cat $2 >> $3
if [$? == 0]
then
    echo "Merged File is"
    cat $3
    exit
fi
echo "Invalid/no input file"