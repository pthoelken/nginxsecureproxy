#!/bin/ash

@reboot with delay

if file exsits 
    -> normal certrenew run

if file not exsits
    -> stop nginx
    -> copy 80-certif-config
    -> start nginx
    -> run certify for new cert
    -> stop nginx
    -> copy original configuration files
    -> start nginx

# && certbot certonly --standalone --agree-tos -m "${CERTBOT_EMAIL}" -n -d ${DOMAIN_LIST} \
# && certbot certonly --webroot --webroot-path=/var/www/certbot --email ${CERTBOT_EMAIL} --agree-tos --no-eff-email -d ${DOMAIN_LIST} \
# && echo "@monthly certbot renew --nginx >> /var/log/cron.log 2>&1" >>/etc/cron.d/certbot-renew \
# && crontab /etc/cron.d/certbot-renew
# && echo "PATH=$PATH" > /etc/cron.d/certbot-renew
# VOLUME /etc/letsencrypt