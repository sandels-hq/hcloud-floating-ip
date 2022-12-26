#!/usr/bin/env bash

(
FLOATING_TABLE=$(echo $FLOATING_IP | sed -e 's/\.//g' | cut -c 2-)

echo "master.sh running $(date)"

# Flush existing floating ip routes and rules
ip rule flush table $FLOATING_TABLE
ip route flush table $FLOATING_TABLE

# Remove old floating ip configurations that might exist
ip addr del $FLOATING_IP/32 dev $FLOATING_INTERFACE 2>&1 > /dev/null
ip rule del from $FLOATING_IP/32 table $FLOATING_TABLE 2>&1 > /dev/null
ip route del 172.31.1.1 dev $FLOATING_INTERFACE table $FLOATING_TABLE 2>&1 > /dev/null
ip route del default via 172.31.1.1 table $FLOATING_TABLE 2>&1 > /dev/null

# Add floating ip routes and rules
ip addr add $FLOATING_IP/32 dev $FLOATING_INTERFACE
ip rule add from $FLOATING_IP/32 table $FLOATING_TABLE
ip route add 172.31.1.1 dev $FLOATING_INTERFACE table $FLOATING_TABLE
ip route add default via 172.31.1.1 table $FLOATING_TABLE

# Assign floating ip to server
hcloud floating-ip assign $FLOATING_IP_ID $HOSTNAME.$DOMAIN

exit 0

) 2>&1 >/tmp/keepalived.log