FROM centos:6.8
RUN yum update -y && yum upgrade -y
RUN yum -y install \
	nano \
	wget \
	unzip \
	php-devel \
	mysql \
	mysql-server \
	vsftpd \
	httpd \
	tar \
	php-gd \
	php-mysql \
	php-pear \
	php-soap \
	ntp \
	openssh-server

ENV EDOMI_TMP_PATH /tmp
ENV EDOMI_ZIP $EDOMI_TMP_PATH/edomi.zip
ENV EDOMI_INSTALL_PATH $EDOMI_TMP_PATH/edomi/Install/
COPY bin/edomi_144.zip $EDOMI_ZIP
RUN unzip -q $EDOMI_ZIP -d $EDOMI_TMP_PATH
COPY bin/install.sh $EDOMI_INSTALL_PATH
RUN cd $EDOMI_INSTALL_PATH && ./install.sh

# set root passwd
RUN echo -e "123456\n123456" | (passwd --stdin root)


# copy entrypoint script
ENV START_SCRIPT /root/start.sh
COPY bin/start.sh $START_SCRIPT
RUN chmod +x $START_SCRIPT
CMD ["/root/start.sh"]

