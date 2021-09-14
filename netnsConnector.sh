#!/bin/bash
NAME=$1
NAMESPACE_IP=$2
BRIDGE_NAME=$3
BRIDGE_IP=$4
VETH_NAME=veth-$NAME

ip netns add $NAME
echo "A new namespace created"

ip link add $VETH_NAME type veth peer name br-$VETH_NAME
echo "A pair of veth created and ready to configure"

ip link set $VETH_NAME netns $NAME
echo "veth has been paired with freshly created namespace"

ip netns exec $NAME \
        ip addr add $NAMESPACE_IP dev $VETH_NAME
        echo "IP Address assigned to veth from inside of the namespace"

var=$(ip link | grep $BRIDGE_NAME)
if [ -n "$var" ]; then
  echo "There is an bridge with this name, no bridge will be created, new namespaces will be added into this bridge"
else
  echo "There is  no bridge with this name, a new bridge will be created now..."
  ip link add name $BRIDGE_NAME type bridge
  echo "Bridge $BRIDGE_NAME created successfuly"
  ip link set $BRIDGE_NAME up
  echo "$BRIDGE_NAME is up"
fi

ip link set br-$VETH_NAME up
echo "br-$VETH_NAME is up"

ip netns exec $NAME \
        ip link set $VETH_NAME up
        echo "$VETH_NAME is up"

ip link set br-$VETH_NAME master $BRIDGE_NAME
echo "br-$VETH_NAME has been paired with $BRIDGE_NAME"

if [ -n "$var" ]; then
  echo "There is an bridge with this name, no IP will be assigned to this bridge"
else
  ip addr add $BRIDGE_IP brd + dev $BRIDGE_NAME
  echo "$BRIDGE_IP assigned to $BRIDGE_NAME"

fi

echo "SUCCESS!"