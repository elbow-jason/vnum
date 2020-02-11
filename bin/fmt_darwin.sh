#!/usr/bin/env bash

grep -rl 'import vnum.' **/*.v | xargs sed -i '' -E 's/(.*)import vnum\.(.*)/\1import \2/g'
v fmt -w **/*.v

for j in consts la num nn
do
    grep -rl "import $j" **/*.v | xargs sed -i '' -E "s/(.*)import $j(.*)/\1import vnum\.$j\2/g"
done