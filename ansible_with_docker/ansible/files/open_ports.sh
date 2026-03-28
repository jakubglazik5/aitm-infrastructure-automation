#!/bin/bash

echo "--- TRYB CERTYFIKATU: OTWIERANIE ---"

# Wstawianie reguł na sam początek (pozycja 1 i 2)
sudo iptables -I INPUT 1 -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT 2 -p tcp --dport 443 -j ACCEPT

echo "Porty 80 i 443 są teraz OTWARTE dla całego świata."
echo "Możesz wygenerować certyfikaty w Evilginx."
echo "Po zakończeniu, koniecznie uruchom ./cert_close.sh"

