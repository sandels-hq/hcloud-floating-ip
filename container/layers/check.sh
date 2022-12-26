#!/usr/bin/env bash

(
/bin/ping -c1 -W1 -q 2>&1 > /dev/null $FLOATING_IP
if [ $? ]; then
  exit 0
else
  echo "Ping failed!"
  exit 1
fi
) 2>&1 >/tmp/keepalived.log