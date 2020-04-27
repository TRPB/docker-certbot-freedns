#!/bin/sh

# Get a list of existing certificates and look for $DOMAIN_NAME
CERTIFICATES=`certbot certificates | grep $DOMAIN_NAME`

# Default renew interval to 12 hours
: ${RENEW_INTERVAL="12h"}

# If there is no certificate, request it, otherwise renew
if [ -z "$CERTIFICATES" ]; then
	certbot certonly -d $DOMAIN_NAME  --agree-tos -m $EMAIL --manual --preferred-challenges=dns --manual-auth-hook=/app/auth-hook.sh --manual-public-ip-logging-ok 
else
	certbot renew --manual --preferred-challenges=dns --manual-auth-hook=/app/auth-hook.sh
fi


while :
do
	echo "Sleeping for $RENEW_INTERVAL before renewing"
	sleep $RENEW_INTERVAL
	certbot renew --manual --preferred-challenges=dns --manual-auth-hook=/app/auth-hook.sh
done