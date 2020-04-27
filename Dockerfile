FROM certbot/certbot

RUN apk --no-cache add curl
RUN mkdir /app

COPY entrypoint.sh /app/entrypoint.sh
COPY auth-hook.sh /app/auth-hook.sh

RUN chmod +x /app/entrypoint.sh
RUN chmod +x /app/auth-hook.sh

ENTRYPOINT ["/app/entrypoint.sh"]