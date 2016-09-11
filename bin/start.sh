#!/bin/sh

service mysqld start
service vsftpd start
service httpd start
service ntpd start
service sshd start

/usr/local/edomi/main/start.sh
