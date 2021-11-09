#!/bin/bash

strDate=$(date +%Y-%m-%d)

strCertifyBaseFolder=/etc/certify

strCertifyConfigFolder=$strCertifyBaseFolder/configs
strCertify80DefaultConfig=$strCertifyConfigFolder/80-foo.bar.conf
strCertify443DefaultConfig=$strCertifyConfigFolder/443-foo.bar.conf
strNginxConfigPath=/etc/nginx/conf.d
strExampleDomainName=example.org

strCertifyDomainFolder=$strCertifyBaseFolder/domains
strCertifyLogFolder=$strCertifyBaseFolder/log
strCertifyLogFinalPath=$strCertifyLogFolder/certify_$strDate.log

strDomainName=""

function Logger() {

    if [ ! -f $strCertifyLogFinalPath ]; then
        touch $strCertifyLogFinalPath
    fi 

    echo -e "$strDate || $1" >> $strCertifyLogFinalPath

}

for strFileName in $strCertifyDomainFolder/*.*; do
    strDomainName=$(basename $strFileName)
    strMailAddress=$(head -n 1 $strFileName)

    cp $strCertify80DefaultConfig $strNginxConfigPath/$strDomainName
    sed -i 's/'$strExampleDomainName'/'$strDomainName'/g' $strNginxConfigPath/$strDomainName
    /etc/init.d/nginx reload

    certbot certonly --non-interactive --webroot --webroot-path=/var/www/certbot --email $strMailAddress --agree-tos --no-eff-email -d $strDomainName

    rm -rf $strFileName
done