#!/bin/sh
# WireGuard status for slstatus (^g^/^r^/^d^ match network-status.sh for dwm status2d)

ifaces=$(wg show interfaces 2>/dev/null)
if [ -n "$ifaces" ]; then
	names=$(echo "$ifaces" | tr '\n' ' ' | sed 's/[[:space:]]*$//')
	printf '^g^WG: %s^d^' "$names"
else
	printf '^r^WG: down^d^'
fi
echo
