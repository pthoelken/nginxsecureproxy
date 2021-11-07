FROM nginx:stable

ARG CERTBOT_EMAIL
ARG DOMAIN_LIST
ARG CERTIFYURL=https://github.com/pthoelken/certify/release
ARG CERTIFYPATH=/usr/bin/

RUN  apt update \
      && /etc/init.d/nginx start \
      && apt -y upgrade \
      && apt -y install cron certbot python-certbot-nginx bash wget \
      && wget ${CERTIFYURL} -o ${CERTIFYPATH} \
      && chmod +x ${CERTIFYPATH}/certify \
      && echo "@reboot certify >> /opt/certify/log/certify.log 2>&1" \
      && rm -rf /var/lib/apt/lists/*

CMD [ "sh", "-c", "cron && nginx -g 'daemon off;'" ]