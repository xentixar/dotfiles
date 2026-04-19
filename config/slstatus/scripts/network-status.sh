#!/bin/sh
# Output: ^g^/^r^ segments for i3bar-style green=available, red=unavailable
# Codes: ^g^ green, ^r^ red, ^d^ default (used by dwm status2d-style bar)
# No wlan0 dependency; detects interfaces.

get_ipv6() {
	ip -6 addr show 2>/dev/null | awk '/inet6/ && !/::1\/128|fe80:/ {print $2}' | cut -d'/' -f1 | head -1
}

get_wlan_iface() {
	for d in /sys/class/net/wlan* /sys/class/net/wlp*; do
		[ -d "$d" ] && basename "$d" && return
	done
}

get_w_line() {
	wlan=$(get_wlan_iface)
	[ -z "$wlan" ] && echo "W: down" && return
	# link quality is 3rd field (0-70) -> scale to 0-100
	perc=$(awk -v i="$wlan" '$1 ~ i":" {gsub(/\\./,"",$3); q=$3+0; if(q>70) q=70; print int(q*100/70); exit}' /proc/net/wireless 2>/dev/null)
	[ -z "$perc" ] && perc="0"
	essid=$(iwgetid -r 2>/dev/null)
	[ -z "$essid" ] && essid="n/a"
	ipv4=$(ip -4 addr show "$wlan" 2>/dev/null | awk '/inet / {print $2}' | cut -d'/' -f1)
	[ -z "$ipv4" ] && ipv4="n/a"
	echo "W: ( ${perc}% at ${essid}) ${ipv4}"
}

get_e_line() {
	ip=$(ip -4 addr show eth0 2>/dev/null | awk '/inet / {print $2}' | cut -d'/' -f1)
	if [ -n "$ip" ]; then
		echo "E: $ip"
	else
		# try common ethernet names
		for iface in enp0s3 enp0s25 eno1; do
			ip=$(ip -4 addr show "$iface" 2>/dev/null | awk '/inet / {print $2}' | cut -d'/' -f1)
			[ -n "$ip" ] && echo "E: $ip" && return
		done
		echo "E: down"
	fi
}

ipv6=$(get_ipv6)
[ -z "$ipv6" ] && ipv6="n/a"
w_line=$(get_w_line)
e_line=$(get_e_line)

# i3bar-style: green if available, red if unavailable (text color only)
if [ "$ipv6" = "n/a" ]; then
	printf '^r^%s^d^' "$ipv6"
else
	printf '^g^%s^d^' "$ipv6"
fi
printf ' | '
if [ "$w_line" = "W: down" ]; then
	printf '^r^%s^d^' "$w_line"
else
	printf '^g^%s^d^' "$w_line"
fi
printf ' | '
if [ "$e_line" = "E: down" ]; then
	printf '^r^%s^d^' "$e_line"
else
	printf '^g^%s^d^' "$e_line"
fi
echo
