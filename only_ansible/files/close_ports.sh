#!/bin/bash
# Lokalizacja: only_ansible/files/close_ports.sh

COUNTRY_CODE="pl"

# 1. Czyszczenie starych reguł
iptables -F INPUT

# 2. Pozwól na ruch powrotny (Stateful)
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# 3. Pozwól na SSH (zmień port jeśli używasz innego niż 22!)
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# 4. Pozwól na DNS (wymagane dla certyfikatów SSL/LetsEncrypt)
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j ACCEPT

# 5. Geoblocking dla HTTP/HTTPS (Porty 80 i 443)
iptables -A INPUT -p tcp -m multiport --dports 80,443 -m set --match-set country_ips src -j ACCEPT

# 6. Odrzuć całą resztę
iptables -P INPUT DROP

echo "Firewall (Standalone) uzbrojony: Tylko ruch z $COUNTRY_CODE ma dostęp do portów 80/443."
