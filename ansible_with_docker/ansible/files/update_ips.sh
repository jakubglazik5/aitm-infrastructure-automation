#!/bin/bash

COUNTRY_CODE="pl"
URL="http://www.ipdeny.com/ipblocks/data/countries/${COUNTRY_CODE}.zone"
TMP_FILE="/tmp/${COUNTRY_CODE}.zone"
SET_NAME="country_ips"
TMP_SET_NAME="${SET_NAME}_temp"

echo "--- Starting GeoIP database update for ${COUNTRY_CODE^^} ---"


echo "[1/4] Downloading latest IP list from ipdeny.com"
if curl -s -f -o $TMP_FILE $URL; then
    echo "Download successful."
else
    echo "ERROR: Failed to download."
    exit 1
fi


echo "[2/4] Prepare new IP list"
sudo ipset create $TMP_SET_NAME hash:net --exist
sudo ipset flush $TMP_SET_NAME

{
  echo "create $TMP_SET_NAME hash:net --exist"
  sed -e "s/^/add $TMP_SET_NAME /" "$TMP_FILE"
} | sudo ipset restore

echo "Loaded successfully."


echo "[3/4] Swapping old list with the new one"
sudo ipset create $SET_NAME hash:net --exist
sudo ipset swap $TMP_SET_NAME $SET_NAME


echo "[4/4] Saving configuration"
sudo ipset destroy $TMP_SET_NAME
sudo ipset save > /etc/ipset.conf
rm $TMP_FILE

echo "--- DONE! IP list is up to date ---"
echo "Active IP ranges: $(sudo ipset list $SET_NAME | grep Number | awk '{print $NF}')"
