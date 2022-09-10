#!/bin/sh
http init

d=~/.ssh
f=$d/authorized_keys
[ -d "$d" ] || { mkdir "$d"; chmod 700 "$d"; }

http fetch https://toast.cafe/toast.ssh "$f".tmp
if [ -f "$f" ]; then
	sort -uo "$f" "$f" "$f".tmp
	rm "$f".tmp
else
	mv "$f".tmp "$f"
fi

chmod 600 "$f"
