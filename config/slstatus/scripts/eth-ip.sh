#!/bin/sh
# Print IPv4 for eth0 or "down". Used for E: block in status.
ip -4 addr show eth0 2>/dev/null | awk '/inet / {print $2}' | cut -d'/' -f1 | grep . || echo down
