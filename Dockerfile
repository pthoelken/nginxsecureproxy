FROM nginx:stable

ARG CERTBOT_EMAIL
ARG DOMAIN_LIST

RUN  apt update \
      && /etc/init.d/nginx start \
      && apt -y upgrade \
      && apt -y install cron certbot python-certbot-nginx bash wget \
      # && certbot certonly --standalone --agree-tos -m "${CERTBOT_EMAIL}" -n -d ${DOMAIN_LIST} \
      # && certbot certonly --webroot --webroot-path=/var/www/certbot --email ${CERTBOT_EMAIL} --agree-tos --no-eff-email -d ${DOMAIN_LIST} \
      && rm -rf /var/lib/apt/lists/* \
      && echo "PATH=$PATH" > /etc/cron.d/certbot-renew  \
      && echo "@monthly certbot renew --nginx >> /var/log/cron.log 2>&1" >>/etc/cron.d/certbot-renew \
      && crontab /etc/cron.d/certbot-renew

# VOLUME /etc/letsencrypt

CMD [ "sh", "-c", "cron && nginx -g 'daemon off;'" ]