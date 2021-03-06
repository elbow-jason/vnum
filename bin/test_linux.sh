#!/usr/bin/env bash

grep -rl 'import vnum.' **/*.v | xargs sed -Ei 's/(.*)import vnum\.(.*)/\1import \2/g'

for module in consts la num nn ndimg
do
    v test $module
done

for module in consts la num nn ndimg
do
    grep -rl "import $module" **/*.v | xargs sed -Ei "s/(.*)import $module(.*)/\1import vnum\.$module\2/g"
done