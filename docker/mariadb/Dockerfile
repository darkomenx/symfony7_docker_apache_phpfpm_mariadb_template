FROM mariadb:10.10.2

COPY ./config/my.cnf /etc/mysql/my.cnf

ENV MYSQL_ROOT_PASSWORD docker
ENV MYSQL_DATABASE my-project-name
#ENV MYSQL_USER root
ENV MYSQL_PASSWORD docker

RUN apt-get -y update
RUN apt-get -y install vim
RUN apt-get -y install net-tools
RUN apt-get -y install iproute2

EXPOSE 3307

CMD ["mysqld"]

