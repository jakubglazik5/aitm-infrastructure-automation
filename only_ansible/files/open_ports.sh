#!/bin/bash

echo "--- Opening all ports (Standard Configuration) ---"

# 1. Resetowanie polityk do stanu ACCEPT
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# 2. Czyszczenie wszystkich reguł i liczników
iptables -F
iptables -X
iptables -Z

# 3. Zapewnienie dostępu SSH (na wszelki wypadek)
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# 4. Pozwolenie na ruch lokalny (loopback)
iptables -A INPUT -i lo -j ACCEPT

echo "Firewall is now OPEN. All ports (80, 443, etc.) are accessible from any IP."
