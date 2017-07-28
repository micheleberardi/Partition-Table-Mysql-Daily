#!/bin/bash

FROM=2017-09          # To Be Configured : Starting date        Accepted format : (YY-MM) or (YY-MM-DD)
TO=2018-02	      # To be configured : Last partition date  Accepted format : (YY-MM) or (YY-MM-DD)

d=$FROM
day=$(echo $d | cut -d\- -f3)
if [ -z $day ] ; then
	d=$(echo "${FROM}-01")
fi
dayto=$(echo $TO | cut -d\- -f3)
if [ -z $dayto ] ; then
        TO=$(echo "${TO}-01")
fi

echo "d=$d==, TO=$TO="
now="$(date +'%d-%m-%Y')"

while [ "$d" != "$TO" ]; do 
	d=$(date -I -d "$d + 1 day")
	y=$(echo $d | cut -d\- -f1)
	m=$(echo $d | cut -d\- -f2 )
	day=$(echo $d | cut -d\- -f3 )
	PARTITION=$(echo "p${y}${m}${day}")
	date=$(date -I -d "$d +  1 day")
	echo "PARTITON ($PARTITION), Date=($date)"
	echo "ALTER TABLE log_trace ADD PARTITION (PARTITION  $PARTITION VALUES LESS THAN ('$date'));" >> /tmp/log_trace_${now}.sql

done



