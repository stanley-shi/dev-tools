# A base centos image with only openssh-server installed and started
#
# VERSION               0.0.1

FROM     centos:latest
MAINTAINER stanley shi

# make sure the package repository is up to date

RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum -y install which coreutils python openssh-server wget ntp gzip tar openssh-clients
RUN echo 'root:changeme' |chpasswd
RUN yum -y install gcc gcc-c++ cmake zlib-devel perl

VOLUME /src
VOLUME /data
VOLUME /root/.m2

RUN mkdir -p /opt

# install JDK
RUN yum -y install java-1.7.0-openjdk java-1.7.0-openjdk-devel
# install maven
WORKDIR /tmp
RUN wget -q http://www.us.apache.org/dist/maven/maven-3/3.2.1/binaries/apache-maven-3.2.1-bin.tar.gz
RUN tar xf apache-maven-3.2.1-bin.tar.gz
RUN mv apache-maven-3.2.1 /opt

# install findbugs
RUN wget -q http://downloads.sourceforge.net/project/findbugs/findbugs/2.0.3/findbugs-2.0.3.tar.gz
RUN tar xf findbugs-2.0.3.tar.gz
RUN mv findbugs-2.0.3 /opt

# install forrest 0.9
RUN wget -q http://www.us.apache.org/dist//forrest/apache-forrest-0.9-dependencies.tar.gz
RUN wget -q http://www.us.apache.org/dist//forrest/apache-forrest-0.9-sources.tar.gz
RUN tar xf apache-forrest-0.9-dependencies.tar.gz
RUN tar xf apache-forrest-0.9-sources.tar.gz
RUN mv apache-forrest-0.9 /opt

# install snappy 1.1.0
RUN wget -q https://snappy.googlecode.com/files/snappy-1.1.1.tar.gz
RUN tar xf snappy-1.1.1.tar.gz
RUN cd snappy-1.1.1 && ./configure && make && make install

WORKDIR /tmp
# install protocol buffer 2.5.0
RUN wget -q https://protobuf.googlecode.com/files/protobuf-2.5.0.tar.gz
RUN tar xf protobuf-2.5.0.tar.gz
RUN cd protobuf-2.5.0 && ./configure && make && make install


# install xerces-c 2.8.0
RUN wget -q http://www.us.apache.org/dist/xerces/c/2/binaries/xerces-c_2_8_0-x86_64-linux-gcc_3_4.tar.gz
RUN tar xf xerces-c_2_8_0-x86_64-linux-gcc_3_4.tar.gz
RUN mv xerces-c_2_8_0-x86_64-linux-gcc_3_4 /opt


# adding things to PATH
RUN touch /root/.bash_profile
RUN echo export ENV_FORREST_HOME=/opt/apache-forrest-0.9 >> /root/.bash_profile
RUN echo export MAVEN_HOME=/opt/apache-maven-3.2.1 >> /root/.bash_profile
RUN echo export XERCESC_HOME=/opt/xerces-c_2_8_0-x86_64-linux-gcc_3_4 >> /root/.bash_profile
RUN echo export FINDBUGS_HOME=/opt/findbugs-2.0.3 >> /root/.bash_profile
RUN echo export PATH=\$MAVEN_HOME/bin/:\$PATH >> /root/.bash_profile

WORKDIR /src
EXPOSE 22
CMD service sshd start && source /root/.bash_profile && /bin/bash
