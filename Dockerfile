FROM nginx:stable

ARG CERTBOT_EMAIL
ARG DOMAIN_LIST
ARG CERTIFYURL=https://raw.githubusercontent.com/pthoelken/nginxsecureproxy/main/certify/certify.sh
ARG CERTIFYPATH=/etc/certify/certify

RUN  apt update \
      && /etc/init.d/nginx start \
      && apt -y upgrade \
      && apt -y install cron certbot python-certbot-nginx bash curl \
      && mkdir -p /etc/certify/ \
      && curl -Lo ${CERTIFYPATH} ${CERTIFYURL} \
      && chmod +x ${CERTIFYPATH} \
      && ln -s ${CERTIFYPATH} /usr/bin/certify \
      && chmod +x /usr/bin/certify \
      && echo "@reboot certify" >>/etc/cron.d/certify \
      && echo "@monthly certbot renew --nginx >> /var/log/cron.log 2>&1" >>/etc/cron.d/certbot-renew \
      && crontab /etc/cron.d/certbot-renew \
      && crontab /etc/cron.d/certify \
      && echo "PATH=$PATH" > /etc/cron.d/certbot-renew \
      && echo "PATH=$PATH" > /etc/cron.d/certify \
      && rm -rf /var/lib/apt/lists/*

CMD [ "sh", "-c", "cron && nginx -g 'daemon off;'" ]