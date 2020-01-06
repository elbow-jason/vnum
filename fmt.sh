#!/usr/bin/env bash

grep -rl 'import vnum.' *.v | xargs sed -Ei 's/(.*)import vnum\.(.*)/\1import \2/g'
v fmt -w **/*.v



for i in consts fft internal la ndarray num
do
    grep -rl "import $j" *.v | xargs sed -Ei "s/(.*)import $j(.*)/\1import vnum\.$j\2/g"
done