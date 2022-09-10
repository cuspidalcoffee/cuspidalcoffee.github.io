#!/bin/sh
bucket=https://minio.toast.cafe/bin
prefix="$(uname -m)"
http init

all=$(s3 list "$bucket" | grep "^$prefix")
[ $# -eq 0 ] && set -- 'c/' 'go/' 'rust/'

for p
do
	add=$(echo "$all" | grep "$p")
	if [ -z "$res" ]; then
		res="$add"
	else
		res=$(printf '%s\n%s' "$res" "$add")
	fi
done

get() {
	for i
	do
		f="${i##*/}"
		f="${f%%@*}"
		http fetch "$bucket/$i" "$f"
		[ -f "$f" ] && chmod +x "$f"
	done
}

res=$(echo "$res" | sort | uniq)
get $res
