!/bin/bash

echo "--- TRYB LABORATORIUM: ZAMYKANIE ---"

# Usuwanie reguł zezwalających na ruch globalny
sudo iptables -D INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -D INPUT -p tcp --dport 443 -j ACCEPT

# Zapisanie stanu, aby blokada była aktywna po restarcie
sudo netfilter-persistent save

echo "Porty 80 i 443 zostały ZAMKNIĘTE dla świata."
echo "Dostęp do nich mają teraz tylko adresy IP z Polski."
echo "Twoje laboratorium Evilginx jest ponownie w trybie ukrytym."

