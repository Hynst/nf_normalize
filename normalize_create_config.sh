#!/bin/bash

vcfs=$1
run_id=$2

touch ${run_id}_config_vcfs.tsv

for vcf in `ls $vcfs | grep -v "tbi"`
do

tmp=${vcf#*_}
s_id=${tmp%_*}
file=${vcfs}/${vcf}

awk -v S_ID="$s_id" -v file="$file" 'BEGIN{print file, S_ID}' | sed 's/ /\t/g' >> ${run_id}_config_vcfs.tsv

done
