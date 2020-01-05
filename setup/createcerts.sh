#/bin/bash

CRT_VALIDITY=3560
CRT_C=DE
CRT_ST=BAVARIAN
CRT_L=MUNICH
CRT_ORG=NWO
CRT_CN=GLOBAL

echo "create a self signed certificate with a validity of $CRT_VALIDITY days"
NX_SSLSUBJECT="/C=$CRT_C/ST=$CRT_ST/L=$CRT_L/O=$CRT_ORG/CN=$CRT_CN"
echo "subject: $NX_SSLSUBJECT"
openssl req -x509 -newkey rsa:4096 -keyout /home/appuser/data/certificates/key.pem -out /home/appuser/data/certificates/cer.pem -days $CRT_VALIDITY -nodes -subj "$NX_SSLSUBJECT"

echo "check if all certificates are there"
if [ ! -f /home/appuser/data/certificates/cer.pem ] || [ ! -f /home/appuser/data/certificates/key.pem ]
then
echo "failed to create certificates"
exit 1
fi