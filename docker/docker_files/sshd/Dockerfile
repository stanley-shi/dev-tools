FROM     centos:latest
MAINTAINER stanley shi

# make sure the package repository is up to date
RUN yum -y install which coreutils python openssh-server wget ntp gzip tar openssh-clients
RUN echo 'root:changeme' |chpasswd
RUN useradd hadoop
RUN echo 'hadoop:hadoop' |chpasswd
RUN service sshd start
RUN service sshd stop
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config


EXPOSE 22
CMD service sshd start && /bin/bash
