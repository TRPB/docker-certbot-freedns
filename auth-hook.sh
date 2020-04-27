#!/bin/sh

: ${TTL=60}

echo "Full Domain: $CERTBOT_DOMAIN"

# Get top domain (e.g. "example.com" from "www.example.com")
DOMAIN=$(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)')

# 'expr match' returns nothing if there's no sub-domain
#    (e.g. "example.com"), so run an alternate search if that happens
if [ -z "$DOMAIN" ]
then
  DOMAIN=$(expr match "$CERTBOT_DOMAIN" '\(.*\..*\)')
fi
echo "Domain: $DOMAIN"

# Get sub-domain (e.g. "www" from "www.example.com")
SUBDOMAIN=$(expr match "$CERTBOT_DOMAIN" '\(.*\)\..*\..*')
if [ -z "$SUBDOMAIN" ]
then
  SUBDOMAIN="(none)"
fi
echo "Sub-domain: $SUBDOMAIN"


SUBDOMAIN_ID="_acme-challenge"


echo "Attempting to use validation token $CERTBOT_VALIDATION with $CERTBOT_DOMAIN"
echo "DOMAIN_ID = $DOMAIN_ID"
echo "SUBDOMAIN ID = $SUBDOMAIN_ID"
echo "DATA_ID = $DATA_ID"
curl -b "dns_cookie=$DNS_COOKIE" -d "type=TXT" -d "subdomain=$SUBDOMAIN_ID" -d "domain_id=$DOMAIN_ID" -d "data_id=$DATA_ID" -d "address=%22$CERTBOT_VALIDATION%22" https://freedns.afraid.org/subdomain/save.php?step=2

echo "Waiting $TTL seconds for DNS to propagate"
# Sleep to make sure the change has time to propagate over to DNS
sleep $TTL

echo "Output: $CERTBOT_AUTH_OUTPUT"
