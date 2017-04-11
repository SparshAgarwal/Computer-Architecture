#!/bin/sh

base=`pwd | sed -e"///g"`;
for a in *.asm; do
    echo "# [[$a|$a]]";
done

rm "all.list";
for a in *.asm; do
    echo $base/$a >> all.list;
done
chmod -R o+r *
