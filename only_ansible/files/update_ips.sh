#!/bin/bash

COUNTRY_CODE="pl"
URL="http://www.ipdeny.com/ipblocks/data/countries/${COUNTRY_CODE}.zone"
TMP_FILE="/tmp/${COUNTRY_CODE}.zone"
SET_NAME="country_ips"
TMP_SET_NAME="${SET_NAME}_temp"

echo "--- Updating GeoIP Database: ${COUNTRY_CODE^^} ---"

# 1. Download fresh IP zones
if curl -s -f -o "$TMP_FILE" "$URL"; then
    echo "[OK] Data downloaded."
else
    echo "[ERR] Download failed."
    exit 1
fi

# 2. Prepare temporary ipset
sudo ipset create "$TMP_SET_NAME" hash:net --exist
sudo ipset flush "$TMP_SET_NAME"

# 3. Fast-load IPs using restore method
{
  echo "create $TMP_SET_NAME hash:net --exist"
  sed -e "s/^/add $TMP_SET_NAME /" "$TMP_FILE"
} | sudo ipset restore

# 4. Atomic swap (zero-downtime update)
sudo ipset create "$SET_NAME" hash:net --exist
sudo ipset swap "$TMP_SET_NAME" "$SET_NAME"

# 5. Cleanup and Persistence
sudo ipset destroy "$TMP_SET_NAME"
sudo ipset save > /etc/ipset.conf
rm "$TMP_FILE"

echo "[DONE] Active ranges: $(sudo ipset list $SET_NAME | grep Number | awk '{print $NF}')"
