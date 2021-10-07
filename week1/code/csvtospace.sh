#!/bin/bash

echo "Creating a space delimited version of $1..."
cat $1 | tr -s "," " " >> $(basename -s "$1").png
exit