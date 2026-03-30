#!/bin/bash

# Konfiguracja
COUNTRY_CODE="pl"
URL="http://www.ipdeny.com/ipblocks/data/countries/${COUNTRY_CODE}.zone"
TMP_FILE="/tmp/${COUNTRY_CODE}.zone"
SET_NAME="country_ips"
TMP_SET_NAME="${SET_NAME}_temp"

echo "--- Rozpoczynam aktualizację bazy GeoIP dla Polski ---"

# 1. Pobieranie nowej listy
echo "[1/4] Pobieranie aktualnej listy IP z ipdeny.com..."
if curl -s -f -o $TMP_FILE $URL; then
    echo "Pobrano pomyślnie."
else
    echo "BŁĄD: Nie udało się pobrać pliku. Sprawdź połączenie."
    exit 1
fi

# 2. Przygotowywanie nowej listy (SZYBKA METODA)
echo "[2/4] Przygotowywanie nowej listy w pamięci RAM..."
sudo ipset create $TMP_SET_NAME hash:net --exist
sudo ipset flush $TMP_SET_NAME

# Tworzymy plik tymczasowy dla ipset restore
{
  echo "create $TMP_SET_NAME hash:net --exist"
  sed -e "s/^/add $TMP_SET_NAME /" "$TMP_FILE"
} | sudo ipset restore

echo "Załadowano pomyślnie."

# 3. Zamiana zbiorów (Swap)
echo "[3/4] Podmiana starej listy na nową (bez przerywania ruchu)..."
# Tworzymy główny zbiór, jeśli jeszcze nie istnieje (np. po czyszczeniu)
sudo ipset create $SET_NAME hash:net --exist
# Szybka zamiana
sudo ipset swap $TMP_SET_NAME $SET_NAME

# 4. Sprzątanie i zapis
echo "[4/4] Zapisywanie konfiguracji na dysku..."
sudo ipset destroy $TMP_SET_NAME
sudo ipset save > /etc/ipset.conf
rm $TMP_FILE

echo "--- GOTOWE! Twoja lista IP z jest aktualna ---"
echo "Liczba aktywnych zakresów: $(sudo ipset list $SET_NAME | grep Number | awk '{print $NF}')"
