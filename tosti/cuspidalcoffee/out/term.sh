#!/bin/sh
bucket=https://minio.toast.cafe/bin
prefix=terminfo
http init

all=$(s3 list "$bucket" | grep "^$prefix")
[ $# -eq 0 ] && set -- '.*'

for p
do
	add=$(echo "$all" | grep "$p")
	if [ -z "$res" ]; then
		res="$add"
	else
		res=$(printf '%s\n%s' "$res" "$add")
	fi
done

res=$(echo "$res" | sort | uniq)
for i in $res; do http fetch "$bucket/$i" "${i#$prefix/}"; done
