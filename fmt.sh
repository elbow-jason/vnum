#!/usr/bin/env bash

for module in consts fft internal la ndarray num
do
    grep -rl 'import vnum.' ./$module/ | xargs sed -Ei 's/(.*)import vnum\.(.*)/\1import \2/g'
done

for module in consts fft internal la ndarray num
do
    v fmt -w $module/*.v
done