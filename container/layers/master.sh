#!/usr/bin/env bash

(
echo "master.sh running $(date), assigning $FLOATING_IP to $HOSTNAME"

# Assign floating ip to server
hcloud floating-ip assign $FLOATING_IP_ID $HOSTNAME.$DOMAIN

exit 0

) 2>&1 >/tmp/keepalived.log