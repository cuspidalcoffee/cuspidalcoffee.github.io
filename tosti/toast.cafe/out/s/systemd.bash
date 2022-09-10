#!/usr/bin/env bash
# generate a simple systemd unit for a given command

user=
group=
workdir=
install=
envs=()
desc=

out=

default() {
	local -n var="$1"
	[ -n "$var" ] || var="$2"
}

while getopts 'u:g:w:Wi:e:d:o:' options; do
	case "$options" in
	u) user="$OPTARG" ;;
	g) group="$OPTARG" ;;
	w) workdir="$OPTARG" ;;
	W) workdir=$(pwd) ;;
	i) install="$OPTARG" ;;
	e) envs+=("$OPTARG") ;;
	d) desc="$OPTARG" ;;
	o) out="$OPTARG" ;;
	?) (
		echo "Usage: systemd.bash"
		printf '\t[%s %s]\n' \
			-u user \
			-g group \
			'-W | -w' workdir \
			-i install-target \
			-e environment-value \
			-d description \
			-o output-file
		printf "\t-- my command goes here\n"
	); exit 0 ;;
	esac
done
shift $((OPTIND-1))
[ $# -ge 1 ] || exit 1 # need command

path() (
	cd $(dirname "$1")
	printf '%s/%s\n' $(pwd) $(basename "$1")
)

cmd="$1"; shift
case "$cmd" in
/*) set -- "$cmd" "$@" ;; # no action needed
*)
	if [ -x "$(pwd)/$cmd" ]; then
		w="$(pwd)/$cmd"
	else
		w=$(command -v "$cmd")
	fi
	
	if [ -x "${w:?Could not find absolute path for $cmd}" ]; then
		set -- "$w" "$@"
	else
		echo "$w is not executable"
		exit 1
	fi
;;
esac

# normalize workdir, but only if it's set and exists on the running system
[ -n "$workdir" ] && [ -d "$workdir" ] && workdir=$(path "$workdir")

default desc "Service for $cmd by https://toast.cafe/s/systemd.sh"
default install multi-user.target

generate() {
	echo '[Unit]'
	echo "Description=${desc:?}"
	echo

	echo '[Service]'
	echo "ExecStart=$@"
	[ -n "$workdir" ] && echo "WorkingDirectory=$workdir"
	[ -n "$user" ] && echo "User=$user"
	[ -n "$group" ] && echo "Group=$group"
	for e in "${envs[@]}"; do
		echo "Environment=$e"
	done
	echo

	echo '[Install]'
	echo "WantedBy=${install:?}"
}

if [ -n "$out" ]; then
	generate "$@" > "$out"
else
	generate "$@"
fi
