#!/usr/bin/env bash

tailer /tmp/keepalived.log &

PRIVATE_IP=$(kubectl get node -o wide | grep $HOSTNAME | awk '{ print $6 }')
PRIVATE_INTERFACE=$(ip addr | grep "inet " | grep $(kubectl get node -o wide | grep $HOSTNAME | awk '{ print $6 }') | awk '{ print $8 }')
FLOATING_INTERFACE_BASE=$(echo $FLOATING_INTERFACE | awk -F':' '{ print $1 }')
FLOATING_TABLE=$(echo $FLOATING_IP | sed -e 's/\.//g' | cut -c 2-)

cp /etc/keepalived/keepalived.conf.template /etc/keepalived/keepalived.conf

if [ "$HOSTNAME" == "$MASTER_NODE" ]; then
    KEEPALIVED_STATE="BACKUP"
    KEEPALIVED_PRIORITY="250"
    sed -i -e 's/STARTUP_SCRIPT/startup_script \/master.sh/g' /etc/keepalived/keepalived.conf
else
    KEEPALIVED_STATE="BACKUP"
    KEEPALIVED_PRIORITY=$(shuf -i 1-199 -n 1)
    sed -i -e 's/STARTUP_SCRIPT/\#/g' /etc/keepalived/keepalived.conf    
fi

UNICAST_PEERS=$(kubectl get node -o wide | grep -v "INTERNAL-IP" | grep -v $PRIVATE_IP | awk '{ print $6 }' | sed -e 's/$/xx/' | tr -d '\n' | sed -e 's/xx$//g')

echo PRIVATE_IP: $PRIVATE_IP
echo PRIVATE_INTERFACE: $PRIVATE_INTERFACE
echo KEEPALIVED_STATE: $KEEPALIVED_STATE
echo KEEPALIVED_PRIORITY: $KEEPALIVED_PRIORITY
echo KEEPALIVED_PASSWORD: $KEEPALIVED_PASSWORD
echo UNICAST_PEERS: $UNICAST_PEERS
echo FLOATING_INTERFACE_BASE: $FLOATING_INTERFACE_BASE

sed -i -e "s/PRIVATE_IP/$PRIVATE_IP/g" /etc/keepalived/keepalived.conf
sed -i -e "s/PRIVATE_INTERFACE/$PRIVATE_INTERFACE/g" /etc/keepalived/keepalived.conf
sed -i -e "s/TRACK_INTERFACE/track_interface {\n        $PRIVATE_INTERFACE\n    }/g" /etc/keepalived/keepalived.conf
sed -i -e "s/KEEPALIVED_STATE/$KEEPALIVED_STATE/g" /etc/keepalived/keepalived.conf
sed -i -e "s/KEEPALIVED_PRIORITY/$KEEPALIVED_PRIORITY/g" /etc/keepalived/keepalived.conf
sed -i -e "s/UNICAST_PEERS/unicast_peer {\n        $UNICAST_PEERS\n    }/g" /etc/keepalived/keepalived.conf
sed -i -e "s/xx/\n        /g" /etc/keepalived/keepalived.conf
sed -i -e "s/KEEPALIVED_PASSWORD/$KEEPALIVED_PASSWORD/g" /etc/keepalived/keepalived.conf
sed -i -e "s/FLOATING_IP/$FLOATING_IP/g" /etc/keepalived/keepalived.conf
sed -i -e "s/FLOATING_INTERFACE_BASE/$FLOATING_INTERFACE_BASE/g" /etc/keepalived/keepalived.conf
sed -i -e "s/FLOATING_INTERFACE/$FLOATING_INTERFACE/g" /etc/keepalived/keepalived.conf
sed -i -e "s/FLOATING_TABLE/$FLOATING_TABLE/g" /etc/keepalived/keepalived.conf

keepalived -n -G -l -D -f /etc/keepalived/keepalived.conf