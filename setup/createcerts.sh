#/bin/bash

# Here are the variables describes, which are used by the script. 
# - CRT_VALIDITY=3650         # days of validity
# - CRT_C=<CountryCode>       # Use the two digits-country-code
# - CRT_S=<State or Province> # e.g. Bavaria
# - CRT_L=<City>              # e.g. Ismaning
# - CRT_OU=<Org.-Unit>        # e.g. IT
# - CRT_CN=<CommonName>       # e.g. mycompany.local
# - CRT_ALTNAME=<IPADDRESS>   # The local IP address or another alternative name
# - CRT_ALTTYPE=<IP|DNS>      # The type of the alternative name

echo "createcerts.sh: Check certificate directory"
if [ ! -d /home/appuser/data/certificates ]; then echo "createcerts: Does not exist, create...."; mkdir /home/appuser/data/certificates; else echo "createcerts: Directory already exist, skip...."; fi

echo "createcerts.sh: Create a self signed certificate with a validity of $CRT_VALIDITY days"
SSLSUBJECT="/C=$CRT_C/ST=$CRT_S/L=$CRT_L/O=$CRT_OU/CN=$CRT_CN"

if [ "$CRT_ALTNAME" == "" ]
then
    echo "createcerts.sh: Subject is \"$SSLSUBJECT\"" 
    openssl req -x509 -newkey rsa:4096 -keyout /home/appuser/data/certificates/key.pem -out /home/appuser/data/certificates/cer.pem -days $CRT_VALIDITY -nodes -subj "$SSLSUBJECT"
else
    if [ "$CRT_ALTTYPE" == "" ]; then echo "Alternative type is not set. Set it statically to DNS."; CRT_ALTTYPE="DNS"; fi
    echo "createcerts.sh: Subject is \"$SSLSUBJECT\", altname is \"$CRT_ALTNAME\", alttype is \"$CRT_ALTTYPE\""
    openssl req -x509 -newkey rsa:4096 -keyout /home/appuser/data/certificates/key.pem -out /home/appuser/data/certificates/cer.pem -days $CRT_VALIDITY -nodes -subj "$SSLSUBJECT" -addext "subjectAltName = ${CRT_ALTTYPE}:${CRT_ALTNAME}"
fi

echo "createcerts.sh: Check if all certificates are there"
if [ ! -f /home/appuser/data/certificates/cer.pem ] || [ ! -f /home/appuser/data/certificates/key.pem ]
then
    echo "createcerts.sh: Failed to create certificates"
    exit 1
else 
    echo "createcerts.sh: Everything fine."
fi