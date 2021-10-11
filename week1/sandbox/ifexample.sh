filenae=`$1`

echo $1

echo $filenae

if [[ $1 == *"test.txt"* ]]; then
    echo "wowwwww"
    exit
fi

echo "noooo"