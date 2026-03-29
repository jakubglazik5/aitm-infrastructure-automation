#!/bin/bash

echo "--- AKTYWACJA BLOKADY GEOIP (POLSKA) ---"

# 1. Czyszczenie starych reguł w łańcuchu DOCKER-USER (bezpieczne dla Dockera)
iptables -F DOCKER-USER

# 2. Pozwól na ruch z Polski (ipset 'poland') na porty 80 i 443
iptables -A DOCKER-USER -p tcp -m multiport --dports 80,443 -m set --match-set poland_ips src -j ACCEPT

# 3. Pozwól na ruch już nawiązany (żeby nie zerwało Twojego połączenia)
iptables -A DOCKER-USER -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# 4. BLOKUJ całą resztę świata na portach 80 i 443
iptables -A DOCKER-USER -p tcp -m multiport --dports 80,443 -j DROP

# 5. Powrót do reszty reguł Dockera
iptables -A DOCKER-USER -j RETURN

echo "Porty 80/443 są teraz dostępne WYŁĄCZNIE dla IP z Polski."
