FROM     my_centos:sshd
MAINTAINER stanley shi

#RUN rm -rf /etc/yum.repos.d/*
#ADD shlab.repo /etc/yum.repos.d/shlab.repo

ADD phd_common.sh /tmp/setup/phd_common.sh
ADD setup_buildenv.sh /tmp/setup/setup_buildenv.sh

RUN /bin/sh /tmp/setup/setup_buildenv.sh

EXPOSE 22
CMD /usr/sbin/sshd && /bin/bash
