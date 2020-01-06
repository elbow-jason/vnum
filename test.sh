#!/usr/bin/env bash

grep -rl 'import vnum.' **/*.v | xargs sed -Ei 's/(.*)import vnum\.(.*)/\1import \2/g'

for module in consts fft internal la ndarray num
do
    v test $module
done

for module in consts fft internal la ndarray num
do
    grep -rl "import $module" **/*.v | xargs sed -Ei "s/(.*)import $module(.*)/\1import vnum\.$module\2/g"
done