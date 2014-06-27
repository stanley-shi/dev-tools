# A base centos image with only openssh-server installed and started
#
# VERSION               0.0.1

FROM     centos:latest
MAINTAINER stanley shi

# make sure the package repository is up to date

VOLUME /src
VOLUME /data
VOLUME /root/.m2

ADD setup_env.sh /tmp/setup_env.sh
RUN sh /tmp/setup_env.sh

WORKDIR /src
EXPOSE 22
CMD service sshd start && source /root/.bash_profile && /bin/bash
