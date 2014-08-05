#!/bin/sh
PCC_TAR=http://hdp4-mdw1.wbe.dh.greenplum.com/dist/PHD/latest/PCC-2.3.0-427.x86_64.tar.gz
PHD_TAR=http://hdp4-mdw1.wbe.dh.greenplum.com/dist/PHD/latest/PHD-2.1.0.0-175.tar.gz
JDK_RPM=http://hdsh2-a255.lss.emc.com/phd-common/jdk-7u45-linux-x64.rpm


mkdir -p /phd
cd /phd
wget $PCC_TAR
wget $PHD_TAR
wget $JDK_RPM

PCC_FILE=$(basename $PCC_TAR)
PHD_FILE=$(basename $PHD_TAR)
JDK_RPM_FILE=$(basename $JDK_RPM)

tar xf $PCC_FILE
tar xf $PHD_FILE

PCC_FOLDER=${PCC_FILE%%.x86_64.tar.gz}
PHD_FOLDER=${PHD_FILE%%.tar.gz}


#install jdk first
rpm -Uvh $JDK_RPM_FILE
alternatives --install "/usr/bin/java" java /usr/java/jdk1.7.0_45/bin/java 1
alternatives --set "java" /usr/java/jdk1.7.0_45/bin/java


#install jdk on other hosts as well
for host in vm2 vm3 vm4 vm5; do
    scp $JDK_RPM_FILE $host:/tmp/
    ssh $host rpm -Uvh /tmp/$JDK_RPM_FILE
    ssh $host alternatives --install "/usr/bin/java" java /usr/java/jdk1.7.0_45/bin/java 1
    ssh $host alternatives --set "java" /usr/java/jdk1.7.0_45/bin/java
done
cd $PCC_FOLDER
yes | ./install

## setup KDC server
echo "This step requires manual intervention!!!"
icm_client security -i

cd ..
sudo -u gpadmin icm_client import -s $PHD_FOLDER

sudo -u gpadmin icm_client fetch-template -o /home/gpadmin/conf

echo before doing anything, copy the clusterConfig.xml to the conf folder
read 

sudo -u gpadmin icm_client deploy -c /home/gpadmin/conf/
