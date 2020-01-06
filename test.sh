#!/usr/bin/env bash

for module in consts fft internal la ndarray num
do
    grep -rl 'import vnum.' *.v | xargs sed -Ei 's/(.*)import vnum\.(.*)/\1import \2/g'
done

for module in consts fft internal la ndarray num
do
    v test $module
done

for i in consts fft internal la ndarray num
do
    for j in consts fft internal la ndarray num
    do 
        grep -rl "import $j" ./$i/ | xargs sed -Ei "s/(.*)import $j(.*)/\1import vnum\.$j\2/g" > /dev/null
    done
done