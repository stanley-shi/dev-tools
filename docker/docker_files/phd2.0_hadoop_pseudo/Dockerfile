# A base centos image with only openssh-server installed and started
#
# VERSION               0.0.1

FROM     centos:latest
MAINTAINER stanley shi

# make sure the package repository is up to date
ADD phd-centos_6.repo /etc/yum.repos.d/phd.repo
#RUM rpm -ivh https://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -ivh http://hdsh2-a255.lss.emc.com/phd-common/jdk-7u45-linux-x64.rpm
#RUN yum -y install supervisor
#ADD supervisord.conf /etc/supervisord.conf

RUN yum -y install hadoop-hdfs-namenode hadoop-conf-pseudo

RUN rm -rf /etc/security/limits.d/{hdfs.conf,mapreduce.conf,yarn.conf}
RUN echo "hdfs   - nofile 4096">>/etc/security/limits.d/hdfs.conf
RUN echo "hdfs   - nproc 4096">>/etc/security/limits.d/hdfs.conf
RUN echo "yarn   - nofile 4096">>/etc/security/limits.d/hdfs.conf
RUN echo "yarn   - nproc 4096">>/etc/security/limits.d/hdfs.conf
RUN echo "mapred - nofile 4096">>/etc/security/limits.d/hdfs.conf
RUN echo "mapred - nproc 4096">>/etc/security/limits.d/hdfs.conf


## need to initialize the hdfs
RUN su -s /bin/bash hdfs -c "hdfs namenode -format"

EXPOSE 22
CMD service sshd start && service hadoop-hdfs-namenode start && service hadoop-hdfs-datanode start  && /bin/bash

