#!/usr/bin/env bash

grep -rl 'import vnum.' **/*.v | xargs sed -i '' -E 's/(.*)import vnum\.(.*)/\1import \2/g'

for module in ndarray num
do
    v test $module
done

for module in consts fft internal la ndarray num
do
    grep -rl "import $module" **/*.v | xargs sed -i '' -E "s/(.*)import $module(.*)/\1import vnum\.$module\2/g"
done