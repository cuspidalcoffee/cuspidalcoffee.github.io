#!/usr/bin/env bash
# this file is licensed under any of the following SPDX licenses
# to be chosen by the user:
# * 0BSD (https://spdx.org/licenses/0BSD.html)
# * BlueOak-1.0.0 (https://blueoakcouncil.org/license/1.0.0)
# * CC0-1.0 (https://creativecommons.org/publicdomain/zero/1.0/)
# * Unlicense (https://unlicense.org/)

shopt -s nullglob

path() (
	cd $(dirname "$1")
	echo $(pwd)/$(basename "$1")
)

src=
out=
data=
datadir=
tmpldir=
index=
file=
execdir=
execute=()

verbose=
clean=
while getopts 's:o:d:D:T:i:f:x:X:vcC' options; do
	case "$options" in
	# src and out are extra-sensitive so we path them
	s) src=$(path "$OPTARG") ;;
	o) out=$(path "$OPTARG") ;;
	d) data="$OPTARG" ;;
	D) datadir="$OPTARG" ;;
	T) tmpldir="$OPTARG" ;;
	i) index="$OPTARG" ;;
	f) file="$OPTARG" ;;
	x) execute+=("$OPTARG") ;;
	X) execdir="$OPTARG" ;;
	v) verbose=1 ;;
	c) clean=1 ;;
	C) clean=2 ;;
	esac
done
shift $((OPTIND-1))
[ $# -ge 1 ] || set -- .

default() {
	local -n var="$1"
	[ -n "$var" ] || var=$(path "$2")
}

default src     "$1"/src
default out     "$1"/out
default data    "$1"/data.yml
default datadir "$1"/data
default tmpldir "$1"/tmpl
default index   "$1"/index.tmpl
default file    "$1"/file.tmpl
default execdir "$1"/exe

log() {
	local category="$1":; shift
	[ -n "$verbose" ] && printf "%s\t%s\n" "$category" "$*"
} >&2

# WARN: this assumes that everything will be under $src
# which it should be
outpath() {
	local p=$(path "$1")
	echo $out${p#"$src"}
}

# common args
gomplate_args=()
[ -f "$data" ]    && gomplate_args+=(-d data="$data")
[ -d "$datadir" ] && gomplate_args+=(-d datadir="$datadir"/)
[ -d "$tmpldir" ] && gomplate_args+=(-t tmpl="$tmpldir")
gomplate() {
	command gomplate "${gomplate_args[@]}" "$@"
}

# index generation requires gomplate and jo
index() (
	log index "$1"/index.html
	
	mkdir -p "$1"
	cd "$1"
	jo -a .. * | gomplate -d index="stdin:///index.json" -f "$index" -o index.html
)

# $1 is file
file() (
	local dir=$(dirname $(outpath "$1"))
	mkdir -p "$dir"

	# attempt eXecute
	for x in "${execute[@]}"; do
		if [ "${1##*.}" = "$x" ] && [ -x "$execdir"/"$x" ]; then
			# $1 is the file to process, $2 is the directory to put it into
			"$execdir"/"$x" "$1" "$dir"
		
			# potentially incorrect output!
			# we can't detect what file is ACTUALLY written to
			log "$x" "$dir"/$(basename "$1")
			return # don't continue handling, it's done now
		fi
	done
	
	case "$1" in
	# markdown requires cmark and gomplate
	*.md)
		local name=$(basename "$1" .md).html
		out="$dir"/"$name"
		cmark --unsafe --smart --nobreaks -t html "$1" |
		gomplate -d content="stdin:" -f "$file" -o "$out"
		
		log md "$out"
	;;
	*)
		cp "$1" "$dir"/
		
		log file "$dir"/$(basename "$1")
	;;
	esac
)

recur() (
	cd "$1"

	local doindex=
	# does this directory have an index?
	if ! [ -f index.html ] && ! [ -f index.md ]
	then
		doindex=y # mark that we want to generate an index
	fi

	for f in * .*; do
		if [ . = "$f" ] || [ .. = "$f" ]; then
			: # skip . and ..
		elif [ -d "$f" ]; then
			recur "$f"
		elif [ -f "$f" ]; then
			file "$f"
		fi
	done

	if [ -n "$doindex" ]; then
		index $(outpath $(pwd))
	fi
)

if [ -n "$clean" ]; then
	rm -r "$out"
	[ "$clean" -gt 1 ] && exit 0
fi
recur "$src"
