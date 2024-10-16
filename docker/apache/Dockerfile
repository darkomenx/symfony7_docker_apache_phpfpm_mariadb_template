FROM ubuntu:jammy-20231211.1

# Apache ENVs
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV APACHE_SERVER_NAME localhost

ARG UNAME=www-data
ARG UGROUP=www-data
ARG UID=1000
ARG GID=1001
RUN usermod  --uid $UID $UNAME
RUN groupmod --gid $GID $UGROUP

RUN echo "root:docker"|chpasswd

RUN apt-get -y update
RUN apt-get -y update --fix-missing

RUN apt-get install -y software-properties-common
RUN apt-get install -y apt-transport-https
RUN apt-get install -y iputils-ping
RUN apt-get install -y net-tools
RUN apt-get install -y iproute2

RUN add-apt-repository ppa:ondrej/php -y

RUN apt-get -y update
RUN apt-get -y install vim
RUN apt-get -y install nano
RUN apt-get -y install curl
RUN apt-get -y install apache2

RUN apt-get -y install libfontconfig1-dev
RUN apt-get -y install libfreetype6
RUN apt-get -y install libfreetype-dev
RUN apt-get -y install libfreetype6-dev

RUN apt-get -y install libjpeg62-dev
RUN apt-get -y install libpng-dev
RUN apt-get -y install libxrender1
RUN apt-get -y install fontconfig
RUN apt-get -y install xfonts-base
RUN apt-get -y install xfonts-75dpi

RUN echo 'tzdata tzdata/Areas select Europe' | debconf-set-selections
RUN echo 'tzdata tzdata/Zones/Europe select Paris' | debconf-set-selections
RUN DEBIAN_FRONTEND="noninteractive" apt install -y tzdata

RUN apt-get -y install libapache2-mod-php7.0
RUN apt-get -y install libapache2-mod-fcgid
RUN apt-get -y install w3m
RUN apt-get install -y dos2unix


RUN mkdir /var/www/my-project-name
RUN mkdir /var/www/my-project-name/public
RUN mkdir /var/www/my-project-name/log

RUN a2enmod proxy_fcgi setenvif
RUN a2enmod rewrite
RUN a2enmod ssl
RUN a2enmod proxy

RUN chmod -R 777 /var/www/my-project-name


COPY ./config/apache2.conf /etc/apache2/apache2.conf
COPY ./config/my-project-name.conf /etc/apache2/sites-available

COPY ./config/my-project-name.crt /etc/apache2/my-project-name.crt
COPY ./config/my-project-name.csr /etc/apache2/my-project-name.csr
COPY ./config/my-project-name.key /etc/apache2/my-project-name.key

COPY ./config/.htaccess /var/www/my-project-name/public/.htaccess
#COPY ./config/.htaccess ./../../.htaccess

COPY ./config/.env.local /var/www/my-project-name
COPY ./config/start.sh /root/start.sh

RUN dos2unix /root/start.sh
RUN a2ensite my-project-name
RUN a2dissite 000-default

RUN service apache2 stop

RUN usermod -u 1000 www-data
RUN groupmod -g 1000 www-data

RUN chmod 777 /root/start.sh
RUN chmod +x /root/start.sh
### SSH config ===============================================================================================

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config


### WKhtmltoPDF =============================================================================================

#COPY ./config/wkhtmltox_0.12.6.1-2.jammy_amd64.deb /root/wkhtmltox_0.12.6.1-2.jammy_amd64.deb

#RUN dpkg -i /root/wkhtmltox_0.12.6.1-2.jammy_amd64.deb

### End Build ===============================================================================================

EXPOSE 443
EXPOSE 22


CMD ["/root/start.sh"]




