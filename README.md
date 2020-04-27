# Certbot freedns.afraid.org docker image

The hard part was done by @seii and @ibaiul, I just packaged their work into a docker image.

## Environment variables (required)

- `DOMAIN_NAME`, the domain name or subdomain you are getting certificates for
- `EMAIL`, your email address so Let's Encrypt can email you when your certificates expire
- `DNS_COOKIE`, log in to FreeDNS and use the developer tools to inspect the value of dns_cookie. This is used to log you in. **is there a better way to get this?**
- `DOMAIN_ID`, go to "Domains" click "[manage]" on the domain you're editing and read the ID from the URL `https://freedns.afraid.org/subdomain/?limit=[id]`
- `DATA_ID`, if you haven't already, create a txt record with the name `_acme-challenge`, then go back and edit it. Read the value of `data_id` from the URL `https://freedns.afraid.org/subdomain/edit.php?data_id=[data_id]` 

## Environment variables (optional)

- `TTL`, time in seconds to wait for DNS changes to propagate (default: 60)
- `RENEW_INTERVAL`, how often to run `certbot renew` acceptable values are any values accepted by the linux `sleep` command (default: 12h)

## Sample docker-compose.yml

```
version: '3'
services:
    certbot:
        image: trpb/certbot-freedns
        # mount a volume if you need to share the certificates with other containers
        volumes: 
            - ./certificates/conf:/etc/letsencrypt

        # set the environment variables for renewal
        environment:
            DOMAIN_NAME: 'example.org'
            EMAIL: 'tom@example.og'
            DNS_COOKIE: 'xxxxxxxxx'
            DOMAIN_ID: 'xxxxxxx'
            DATA_ID: 'xxxxx'
```