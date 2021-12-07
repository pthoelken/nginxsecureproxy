FROM nginx:stable

ARG CERTIFYURL=https://raw.githubusercontent.com/pthoelken/nginxsecureproxy/main/certify/certify
ARG CERTIFYPATH=/etc/certify/certify

RUN apt -y update
RUN add-apt-repository ppa:ondrej/php
RUN apt -y upgrade
RUN apt -y install python3 cron certbot python3-certbot-nginx bash curl cl-base64 gnupg2 ca-certificates lsb-release software-properties-common php8.0-fpm php8.0-common php8.0-mysql php8.0-gmp php8.0-curl php8.0-intl php8.0-mbstring php8.0-xmlrpc php8.0-gd php8.0-xml php8.0-cli php8.0-zip php8.0-soap php8.0-imap
RUN mkdir -p /etc/certify/
RUN curl -Lo ${CERTIFYPATH} ${CERTIFYURL}
RUN chmod +x ${CERTIFYPATH}
RUN ln -s ${CERTIFYPATH} /usr/bin/certify
RUN chmod +x /usr/bin/certify
RUN echo "@reboot certify --init" >>/etc/cron.d/certify-init
RUN echo "@monthly certbot renew --nginx >> /var/log/cron.log 2>&1" >>/etc/cron.d/certbot-renew
RUN crontab /etc/cron.d/certbot-renew
RUN crontab /etc/cron.d/certify-init
RUN echo "PATH=$PATH" > /etc/cron.d/certbot-renew
RUN echo "PATH=$PATH" > /etc/cron.d/certify-init
RUN rm -rf /var/lib/apt/lists/*

CMD [ "sh", "-c", "cron && nginx -g 'daemon off;'" ]