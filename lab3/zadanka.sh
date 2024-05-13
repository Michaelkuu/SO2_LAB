#!/bin/bash

#fakaping.sh:
./fakaping.sh > /dev/null | sort
./fakaping.sh 2>&1 | sort -u | tee all.log

#access_log:
grep -oE '^([0-9]{1,3}\.){3}[0-9]{1,3}' access_log.txt | sort | uniq | head -n 10


#groovies:

#yolo.csv:
grep -E '^([^,][13579],)' yolo.csv 1>&2
grep -oE '\b[0-9].[0-9].[0-9].[0-9]*\b' yolo.csv

