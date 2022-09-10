#!/bin/sh
# this file is licensed under any of the following SPDX licenses
# to be chosen by the user:
# * 0BSD (https://spdx.org/licenses/0BSD.html)
# * BlueOak-1.0.0 (https://blueoakcouncil.org/license/1.0.0)
# * CC0-1.0 (https://creativecommons.org/publicdomain/zero/1.0/)
# * Unlicense (https://unlicense.org/)

## util.sh:
# this is a set of utilities to quickly get shell scripts going
# it's also useful for web-enabled scripts that are distributed via http
# for the web-enabled use-case, cat this file with your actual script
# in a preprocessing step.
# everything in here should be POSIXLY correct.
# if it isn't, let me know! <toast (at) bunkerlabs.net>

## Utilities:
# hascmd: returns true if ALL of the arguments are executables in PATH

# http: has subcommands:
#	init:  initializes HTTP_FETCH and HTTP_PRINT from the priority list
#	url:   returns true if every argument looks like an http url, else false.
#	       note that "looks like" is a very rudimentary ERE.
#	fetch: downloads $1 to $2, creating any needed intermediary directories
#	print: downloads $1 and prints it to stdout, assumes utf-8
#	eval:  downloads $1 and runs eval on it
#	src:   downloads $1 and dot-sources it, passing remaining options.
#	       note that it will leak an "f" variable.
#	run:   downloads $1 and runs it, passing remaining options
#	note that http does not perform argument validation.

# log: equivalent to echo >&2 unless QUIET is set and non-empty

# maketemp: a wrapper around mktemp,
#	and a portable implementation thereof if it's not found.
#	no flags are supported. the portable implementation has 2 bytes of entropy.
#	for -d, run rm then mkdir.

# s3: has subcommands:
#	list: lists all of the keys in an s3 bucket

# truepath: a wrapper around realpath/readlink-f with a convenience joiner, 
#	and a portable implementation thereof if they're not found.
#	fails horribly if the path doesn't exist

hascmd() {
	for cmd; do
		cmd=$(command -v "$cmd")
		if [ -z "$cmd" ] || ! [ -x "$cmd" ]; then
			return 1
		fi
	done
	return 0
}

log() {
	[ -n "$QUIET" ] || echo "$*"
} >&2

maketemp() {
	if hascmd mktemp; then
		mktemp
	else (
		if [ -d /tmp ]; then cd /tmp; fi
		while : ; do
			suf=$(od -An -N2 -td /dev/random)
			fil=$(printf 'tmp.%d' $suf)
			test -f $fil && continue
			touch $fil
			echo $fil
		done
	)
	fi
}

truepath() {
	[ $# -eq 0 ] && set -- "$0"
	[ $# -gt 1 ] && set -- "$*"
	
	if hascmd realpath; then
		realpath "$1"
	elif hascmd readlink; then
		readlink -f "$1"
	else (
		dir=$(dirname "$1")
		fil=$(basename "$1")
		cd "$dir"
		echo "$(pwd -P)"/"$fil"
	)
	fi
}

http() {
	case "$1" in
	init)
		if [ -z "$HTTP_FETCH" ]; then
			for c in curl wget ht xh; do
				hascmd "$c" || continue
				export HTTP_FETCH=$c
				break
			done
			log "Using ${HTTP_FETCH:?could not find an http fetcher} for http fetching."
		fi
		if [ -z "$HTTP_PRINT" ]; then
			for c in curl ht xh wget; do
				hascmd "$c" || continue
				export HTTP_PRINT=$c
				break
			done
			log "Using ${HTTP_PRINT:?could not find an http printer} for http printing."
		fi
	;;
	url)
		shift
		for u; do
			echo "$u" | grep -Eq '^https?://[^[:space:]]+\.[^[:space:]]+$' || return 1
		done
		return 0
	;;
	fetch)
		http init
		shift

		(
			target=$(dirname "$2")
			mkdir -p "$target"
		)
		log fetch "$2"
		
		case "$HTTP_FETCH" in
		curl) curl -so "$2" "$1" ;;
		ht) ht --ignore-stdin -bdo "$2" --overwrite "$1" ;;
		wget) wget -qO "$2" "$1" ;;
		xh) xh -Ibdo "$2" "$1" ;;
		*) echo Invalid http fetching utility "[$HTTP_FETCH]". >&2; return 1 ;;
		esac >/dev/null
	;;
	print)
		http init
		shift
		
		case "$HTTP_PRINT" in
		curl) curl -s "$1" ;;
		ht) ht --ignore-stdin -b "$1" ;;
		wget) wget -qO- "$1" ;;
		xh) xh -Ib "$1" ;;
		*) echo Invalid http printing utility "[$HTTP_PRINT]". >&2; return 1 ;;
		esac
	;;
	eval) shift; eval $(http print "$1") ;;
	
	src)
		shift
		local f=$(maketemp)
		http_fetch "$1" "$f"
		shift
		. "$f" "$@"
		rm "$f"
	;;
	run)
		shift
		set -- "$(maketemp)" "$@"
		http fetch "$2" "$1"
		(
			cmd="$1"
			shift 2
			"$cmd" "$@"
			rm "$cmd"
		)
	;;
	
	*) echo Invalid http subcommand "[$1]". >&2; return 1 ;;
	esac
}

s3() {
	case "$1" in
	list)
		shift
		
		http print "$1" |
		sed 's/</\n</g' |
		sed '/<Key>/!d;s/^<Key>//'
	;;
	*) echo Invalid s3 subcommand "[$1]". >&2; return 1 ;;
	esac
}

# ----
