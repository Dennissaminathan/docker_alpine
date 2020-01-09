#/bin/bash

# - CRT_VALIDITY=3650       # days of validity
# - CRT_C=DE           # Country
# - CRT_S=BAVARIAN          # State
# - CRT_L=HOERGERTSHAUSEN   # City
# - CRT_OU=FRICKELDAVE      # Organization
# - CRT_CN=PROXY.GLOBAL     # Common name

echo "createcerts.sh: Check certificate directory"
if [ ! -d /home/appuser/data/certificates ]; then echo "createcerts: Does not exist, create...."; mkdir /home/appuser/data/certificates; else echo "createcerts: Already exist, skip...."; fi

echo "createcerts.sh: Create a self signed certificate with a validity of $CRT_VALIDITY days"
SSLSUBJECT="/C=$CRT_C/ST=$CRT_S/L=$CRT_L/O=$CRT_OU/CN=$CRT_CN"

echo "createcerts.sh: Subject for new certificate is ""$SSLSUBJECT"""
openssl req -x509 -newkey rsa:4096 -keyout /home/appuser/data/certificates/key.pem -out /home/appuser/data/certificates/cer.pem -days $CRT_VALIDITY -nodes -subj "$SSLSUBJECT"

echo "createcerts.sh: Check if all certificates are there"
if [ ! -f /home/appuser/data/certificates/cer.pem ] || [ ! -f /home/appuser/data/certificates/key.pem ]
then
    echo "createcerts.sh: Failed to create certificates"
    exit 1
fi