if [ "$#" -ne 1 ]
then
  echo "Usage: Must supply a domain name"
  exit 1
fi

DOMAIN=$1

PATH="."
SERVER_KEY="$PATH/$DOMAIN.key"
SERVER_CSR="$PATH/$DOMAIN.csr"
SERVER_CRT="$PATH/$DOMAIN.crt"
EXTFILE="$PATH/cert_ext.cnf"
COMMON_NAME="$1"

# generating server key
echo "Generating private key"
/usr/bin/openssl genrsa -out $SERVER_KEY  4096 2>/dev/null
if [ $? -ne 0 ] ; then
   echo "ERROR: Failed to generate $SERVER_KEY"
   exit 1
fi

## Update Common Name in External File
/bin/echo "commonName              = $COMMON_NAME" >> $EXTFILE

# Generating Certificate Signing Request using config file
echo "Generating Certificate Signing Request"
/usr/bin/openssl req -new -key $SERVER_KEY -out $SERVER_CSR -config $EXTFILE 2>/dev/null
if [ $? -ne 0 ] ; then
   echo "ERROR: Failed to generate $SERVER_CSR"
   exit 1
fi

echo "Generating self signed certificate"
/usr/bin/openssl x509 -req -days 3650 -in $SERVER_CSR -signkey $SERVER_KEY -out $SERVER_CRT 2>/dev/null
if [ $? -ne 0 ] ; then
   echo "ERROR: Failed to generate self-signed certificate file $SERVER_CRT"
fi
