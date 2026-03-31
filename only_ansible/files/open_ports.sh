#!/bin/bash

echo "--- CERTIFICATE MODE: Opening ---"

iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

iptables -F
iptables -X
iptables -Z

iptables -A INPUT -p tcp --dport 22 -j ACCEPT

iptables -A INPUT -i lo -j ACCEPT

echo "Ports 80 and 443 are open for whole world now."
echo "You can generate certificates in Evilginx."
echo "After finish, start ./cert_close.sh to secure your server."
