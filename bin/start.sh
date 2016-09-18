#!/bin/sh

HOSTIP="192.168.178.35"

HTTPD_CONF="/etc/httpd/conf/httpd.conf"
EDOMI_CONF="/usr/local/edomi"

sed -i -e "s#global_serverIP.*#global_serverIP='$HOSTIP'#" $EDOMI_CONF/edomi.ini
sed -i -e "s/^ServerName.*/ServerName $HOSTIP/g" $HTTPD_CONF

service mysqld start
service vsftpd start
service httpd start
service ntpd start
service sshd start

/usr/local/edomi/main/start.sh &

trap 'exit 0' SIGTERM
while true; do :; done
