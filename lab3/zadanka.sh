#!/bin/bash

#fakaping.sh:
./fakaping.sh > /dev/null 2>&1 | sort
./fakaping.sh 2>&1 | sort -u | tee all.log

#access_log:
grep -oE '^([0-9]{1,3}\.){3}[0-9]{1,3}' access_log.txt | sort | uniq | head -n 10
grep '"DELETE' access_log.txt | awk '{print $7}' | sort | uniq

#groovies:

#yolo.csv:
grep -E '^([^,][13579],)' yolo.csv 1>&2
grep -E '\$2\.99|\$5\.99|\$9\.99' yolo.csv | awk -F, '{print $3, $7}' 1>&2

