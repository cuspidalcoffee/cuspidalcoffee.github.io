#!/bin/sh
http init

# set up / update binary
bin() {
	mkdir -p /usr/local/bin
	cd /usr/local/bin
	http print https://toast.cafe/dl.sh | sh -s caddy
	setcap 'cap_net_bind_service=+ep' caddy
} >&2

# set up / update openrc init script
openrc() {
	http fetch https://raw.githubusercontent.com/CosmicToast/init/master/caddy/caddy.initd /etc/init.d/caddy
	chmod +x /etc/init.d/caddy
	rc-update add caddy
} >&2

# set up user account
user() {
	addgroup -S caddy
	adduser -h /var/lib/caddy -s /sbin/nologin -G caddy -S caddy
} >&2

dobin=yes
dorc=no
douser=no

while getopts Bru name
do
	case $name in
	B) dobin=no ;;
	r) dorc=yes ;;
	u) douser=yes ;;
	?)	echo "-B: don't install/update binary">&2
		echo "-r: don't install/update openrc">&2
		echo "-u: don't initialize a user">&2
		exit 2 ;;
	esac
done

[ "$douser" = yes ] && user
[ "$dorc" = yes ]   && openrc
[ "$dobin" = yes ]  && bin
