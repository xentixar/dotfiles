#!/bin/sh
# Pick a WireGuard interface with dmenu when several exist; run wg-quick via sudo.
# Usage: wg-quick-dmenu.sh up | down
#
# /etc/wireguard is usually mode 0700 (root-only list). Config names are discovered
# with sudo ls, not a user glob — see sudoers.d/99-wg-quick-nopasswd.

WG_DIR=/etc/wireguard

# Match slstatus/dwm dmenu colors (config.h)
dmenu_wg() {
	dmenu -b -fn "DejaVu Sans Mono:size=8" -nb "#000000" -nf "#ceecee" -sb "#285577" -sf "#ffffff" "$@"
}

pick_one() {
	title=$1
	file=$2
	if ! [ -s "$file" ]; then
		notify-send -t 3000 WireGuard "Nothing to $title." 2>/dev/null || true
		exit 0
	fi
	n=$(wc -l <"$file" | tr -d ' ')
	if [ "$n" -eq 1 ]; then
		head -n1 "$file"
	else
		choice=$(sort -u "$file" | dmenu_wg -p "wg-quick $title:") || exit 0
		printf %s "$choice"
	fi
}

case "$1" in
up)
	tmp=$(mktemp)
	run=$(mktemp)
	trap 'rm -f "$tmp" "$run"' EXIT INT TERM
	: >"$tmp"
	wg show interfaces 2>/dev/null >"$run" || true

	# Prefer listing as user; if dir is 0700 (default), fall back to sudo -n (see sudoers.d).
	out=$(/usr/bin/ls -1 -- "$WG_DIR" 2>/dev/null) || out=
	if ! printf %s "$out" | grep -q '\.conf$'; then
		out=$(sudo -n /usr/bin/ls -1 -- "$WG_DIR" 2>/dev/null) || out=
	fi
	if ! printf %s "$out" | grep -q '\.conf$'; then
		notify-send -t 6000 WireGuard "No *.conf visible in $WG_DIR. Install the /usr/bin/ls line from dotfiles config/dwm/sudoers.d/99-wg-quick-nopasswd (or make the directory listable)." 2>/dev/null || true
		exit 1
	fi
	printf %s "$out" | sed -n 's/\.conf$//p' | sort -u | while read -r name; do
		[ -n "$name" ] || continue
		if grep -qx "$name" "$run" 2>/dev/null; then
			continue
		fi
		echo "$name" >>"$tmp"
	done
	if ! [ -s "$tmp" ]; then
		notify-send -t 3000 WireGuard "All configured interfaces are already up." 2>/dev/null || true
		exit 0
	fi
	iface=$(pick_one up "$tmp")
	;;
down)
	tmp=$(mktemp)
	trap 'rm -f "$tmp"' EXIT INT TERM
	wg show interfaces 2>/dev/null >"$tmp" || true
	if ! [ -s "$tmp" ]; then
		notify-send -t 3000 WireGuard "No interface is up." 2>/dev/null || true
		exit 0
	fi
	iface=$(pick_one down "$tmp")
	;;
*)
	echo "usage: $0 up | down" >&2
	exit 2
	;;
esac

[ -n "$iface" ] || exit 0
case "$iface" in
*[!a-zA-Z0-9_-]*)
	exit 1
	;;
esac

exec sudo /usr/bin/wg-quick "$1" "$iface"
