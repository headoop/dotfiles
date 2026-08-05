#!/usr/bin/bash

# list up to 20 plugins
l=$(awk '/use =/ {print $6 "\n" $14 "\n" $22 "\n" $30 "\n" $38 "\n" $46 "\n" $54 "\n" $62 "\n" $70 "\n" $78 "\n" $86 "\n" $94 "\n" $102 "\n" $110 "\n" $118 "\n" $126 "\n" $134 "\n" $142 "\n" $150 "\n" $158}' package.toml)
count=0
for line in $l; do
        echo ya pack -a ${line%,}
        count=$(( $count + 1 ))
done
# if [ $count -ge 20 ]; then
if [ $count -ge 20 ]; then
        echo ATTENTION: max \$count reached
fi
