#!/bin/sh

for i in autoconf; do
    echo "$i"
    $i
    if [ $? -ne 0 ]; then
	echo "Error $? in $i"
	exit 1
    fi
done

echo "./configure --enable-autogen --with-lg-page=14 $@"
./configure --enable-autogen --with-lg-page=14 $@
if [ $? -ne 0 ]; then
    echo "Error $? in ./configure"
    exit 1
fi
