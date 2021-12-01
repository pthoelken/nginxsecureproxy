FROM nginx:stable

ARG CERTIFYURL=https://raw.githubusercontent.com/pthoelken/nginxsecureproxy/main/certify/certify
ARG CERTIFYPATH=/etc/certify/certify

RUN apt update
RUN apt -y upgrade
RUN apt -y install python3 cron certbot python3-certbot-nginx bash curl
RUN mkdir -p /etc/certify/
RUN curl -Lo ${CERTIFYPATH} ${CERTIFYURL}
RUN chmod +x ${CERTIFYPATH}
RUN ln -s ${CERTIFYPATH} /usr/bin/certify
RUN chmod +x /usr/bin/certify
RUN echo "@reboot certify" >>/etc/cron.d/certify
RUN echo "@monthly certbot renew --nginx >> /var/log/cron.log 2>&1" >>/etc/cron.d/certbot-renew
RUN crontab /etc/cron.d/certbot-renew
RUN crontab /etc/cron.d/certify
RUN echo "PATH=$PATH" > /etc/cron.d/certbot-renew
RUN echo "PATH=$PATH" > /etc/cron.d/certify
RUN rm -rf /var/lib/apt/lists/*

CMD [ "sh", "-c", "cron && nginx -g 'daemon off;'" ]

# python-certbot-nginx