#!/bin/bash

echo "--- CERTIFICATE MODE: CLOSING ---"

# Flush existing DOCKER-USER rules
iptables -F DOCKER-USER

# Allow HTTP/HTTPS traffic from the authorized GeoIP set
iptables -A DOCKER-USER -p tcp -m multiport --dports 80,443 -m set --match-set country_ips src -j ACCEPT

# Manitain established and related connections to prevent sessions drops
iptables -A DOCKER-USER -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Drop all other external HTTP/HTTPS traffic
iptables -A DOCKER-USER -p tcp -m multiport --dports 80,443 -j DROP

# Return to default Docker routing
iptables -A DOCKER-USER -j RETURN

echo "Ports 80 and 443 are closed to the IP set."
