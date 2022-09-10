#!/bin/sh
http init

# publish current directory as its basename with anon ro rsync

# set PORT to override what port rsync listens on
# default is 873 for root, 8873 for other users

if [ -z "$PORT" ] && [ "$(id -u)" -ne 0 ]; then
	PORT="--port=8873"
else # port is set, make it a flag
	PORT="--port=$PORT"
fi

# generate config
CONFIG=/tmp/rsync.$$.conf
cat >$CONFIG <<EOF
# breaks on some temporary directories and similar
use chroot = false
[$(basename $PWD)]
	path = $PWD
EOF

cd /tmp
RM='echo keeping existing rsync'
if [ ! -x /tmp/rsync ]; then
	RM='rm -f /tmp/rsync'
	http print https://toast.cafe/dl.sh | sh -s rsync
fi

/tmp/rsync --daemon --config=$CONFIG --no-detach $PORT

rm -f $CONFIG
$RM
