#!/bin/bash

echo "--- CERTIFICATE MODE: CLOSING ---"

COUNTRY_CODE="pl"

# Flush previous rules
iptables -F INPUT

# Allow Stateful Inspection
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Allow SSH traffic
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow DNS traffic
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j ACCEPT

# Whitelist for HTTP/HTTPS
iptables -A INPUT -p tcp -m multiport --dports 80,443 -m set --match-set country_ips src -j ACCEPT

# Reject other traffic
iptables -P INPUT DROP

echo "Ports 80 and 443 are open for the IP set."
