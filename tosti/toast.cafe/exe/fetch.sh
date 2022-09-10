#!/bin/sh
# this file is licensed under any of the following SPDX licenses
# to be chosen by the user:
# * 0BSD (https://spdx.org/licenses/0BSD.html)
# * BlueOak-1.0.0 (https://blueoakcouncil.org/license/1.0.0)
# * CC0-1.0 (https://creativecommons.org/publicdomain/zero/1.0/)
# * Unlicense (https://unlicense.org/)

# this all works with toybox, busybox and coreutils
# everything except http_src and http_run is POSIXLY correct
# http_src and http_run are exceptions due to needing mktemp

# the main issue with this is you ultimately need to fetch it too
# because of this, http_eval, http_run and http_src are provided
# the idea is that you copy paste this at the start of your script,
# then use those to run your *actual* script, with all the stuff set
# this is a bit awkward, but tends to provide the best user experience
# as such, this file is the only code that gets duplicated

# priority list for utilities, they're tried in order
# you're not allowed to overwrite them because _fetch and _print
# behavior is hardcoded

# download speed order
HTTP_FETCH_LIST='curl wget ht xh'

# wget is a bit awkward on busybox-likes with tls
HTTP_PRINT_LIST='curl ht xh wget'

# $1: the command to check
# returns true on null input
hascmd() {
	test -x "$(command -v $1)"
}

# detect http getting for downloads
if [ -z "$HTTP_FETCH" ]; then
	for c in $HTTP_FETCH_LIST
	do
		hascmd $c || continue
		HTTP_FETCH=$c
		break
	done
	echo "Using ${HTTP_FETCH:?could not find an http fetcher} for http fetching."
fi

# detect http getting for piping
if [ -z "$HTTP_PRINT" ]; then
	for c in $HTTP_PRINT_LIST
	do
		hascmd $c || continue
		HTTP_PRINT=$c
		break
	done
	echo "Using ${HTTP_PRINT:?could not find an http printer} for http piping."
fi

# for http_run
export HTTP_FETCH HTTP_PRINT

# $1 is the url
# $2 is the destination file
# intermediate directories are automatically handled
http_fetch() {
	mkdir -p "$(dirname $2)"

	echo "fetch $2" >&2
	case "$HTTP_FETCH" in
	curl) curl -so "$2" "$1" ;;
	ht) ht --ignore-stdin -bdo "$2" --overwrite "$1" ;;
	wget) wget -qO "$2" "$1" ;;
	xh) xh -Ibdo "$2" "$1" ;;
	*) echo 'Invalid http fetching utility.' >&2; exit 1 ;;
	esac >/dev/null
}

# $1 is the url
http_print() {
	case "$HTTP_PRINT" in
	curl) curl -s "$1" ;;
	ht) ht --ignore-stdin -b "$1" ;;
	wget) wget -qO- "$1" ;;
	xh) xh -Ib "$1" ;;
	*) echo 'Invalid http printing utility.' >&2; exit 1 ;;
	esac
}

# $1 is the url
# prints the file to use
http_run_src_prep() {
	f=$(mktemp)
	http_fetch "$1" "$f"
	echo "$f"
}

# $1 is the url
# args are not allowed
# don't use this unless you know what you're doing
http_eval() {
	eval "$(http_print $1)"
}

# $1 is the url
# rest are args to pass
http_run() {
	f="$(http_run_src_prep $1)"
	shift
	chmod +x "$f"
	"$f" "$@"
	rm "$f"
}

# $1 is the url
# rest are args to pass
http_src() {
	f="$(http_run_src_prep $1)"
	shift
	. "$f" "$@"
	rm "$f"
}

# print all keys in an s3 bucket
# $1 is the bucket url
s3_list() {
	http_print "$1" |
	sed 's/</\n</g' |
	sed '/<Key>/!d;s/^<Key>//'
}

# ----
