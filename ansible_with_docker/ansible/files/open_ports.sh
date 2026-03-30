#!/bin/bash

echo "--- CERTIFICATE MODE: OPENING ---"

sudo iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT 2 -p tcp --dport 443 -j ACCEPT

echo "Ports 80 and 443 are open for whole world now."
echo "You can generate certificates in Evilginx."
echo "After finish, start ./cert_close.sh to secure your server."

