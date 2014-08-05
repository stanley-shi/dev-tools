#! /bin/bash
#-------------------------------------------------------------------------------------
# Author: Mingjiang Shi
# Last modified: Fri Nov 29, 2013  03:39PM
#
# Change history:
# 09/20/2013 - initial creation
# 09/22/2013 - Added support for hadoop MR1 build
#-------------------------------------------------------------------------------------
declare top=$(cd $(dirname $0); pwd) # the absolution path of the folder containing this script
declare common_func=$top/phd_common.sh

buildtools_root=/opt/buildtools
tmpdir=/tmp/$USER/buildtools
findbugs_name=findbugs-2.0.2-source.zip
#-------------------------------------------------------------------------------------
# check if the given rpm package is installed or not, install it if not installed.
#-------------------------------------------------------------------------------------
function checkAndInstallRpmPkg
{
  for pkg in $*
  do
    rpm -q $pkg > /dev/null 2>&1
    if [ $? -ne 0 ];then
      info "$pkg not installed on the system. Try to install it..."
      yum -y install $pkg || die "Unable to install $pkg. Please try again or install it manually."
    fi
  done
}

function download
{
  [ -d $tmpdir ] && rm -rf $tmpdir
  mkdir -p $tmpdir
  cd $tmpdir
  local wget_prefix="ftp://10.37.7.163/buildtools"

  info "Downloading findbugs..."
  wget $wget_prefix/$findbugs_name || die "Failed to download findbugs."

  info "Downloading forrest..."
  wget $wget_prefix/apache-forrest-0.9-sources.tar.gz || die "Failed to download forrest 0.9."
  wget $wget_prefix/apache-forrest-0.9-dependencies.tar.gz || die "Failed to download forrest 0.9."
  wget $wget_prefix/apache-forrest-0.8.tar.gz || die "Failed to download forrest 0.8."
  [ $? -ne 0 ] && die "Failed to download forrest." 

  info "Downloading protobuf..."
  wget $wget_prefix/protobuf-2.5.0.tar.gz || die "Failed to download protocol buffer 2.5.0."
  wget $wget_prefix/protobuf-2.4.1.tar.gz || die "Failed to download protocol buffer 2.4.1."

  info "Downloading snappy..."
  wget $wget_prefix/snappy-1.1.0.tar.gz || die "Failed to download snappy"
  
  info "Downloading Ant..."
  wget $wget_prefix/apache-ant-1.8.4-bin.tar.gz || die "Failed to download Ant 1.8.4."
  wget $wget_prefix/apache-ant-1.7.1-bin.tar.gz || die "Failed to download Ant 1.7.1." 

  info "Downloading Maven..."
  wget $wget_prefix/apache-maven-3.0.5-bin.tar.gz  || die "Failed to download Maven."
  
  info "Downloading JKD7..." 
  wget $wget_prefix/jdk-7u15-linux-x64.tar || die "Failed to download JDK7."""
  
  info "Downloading JDK6..."
  wget $wget_prefix/jdk-6u45-linux-x64.bin || die "Failed to download JDK6."
  
  info "Downloading JDK5..."
  wget $wget_prefix/jdk1.5.0_22-linux-amd64.tar.gz || die "Failed to download JDK5."

  info "Downloading Xerces-c..."
  wget $wget_prefix/xerces-c_2_8_0-x86_64-linux-gcc_3_4.tar.gz || die "Failed to download Xerces-c."

  info "Downloading p4 cli..."
  wget $wget_prefix/p4 || die "Failed to download p4"

  info "All the software can be found at $tmpdir."
}

function install
{
  # install the rpm first as installing the protocol buffers requires gcc
  info "Installing rpms..."
  checkAndInstallRpmPkg $RPM_DEPENDENCIES

  # clean the startup scripts
  phd_dev_csh=/etc/profile.d/phd_dev.csh
  phd_dev_sh=/etc/profile.d/phd_dev.sh
  [ -f $phd_dev_sh ] && rm -f $phd_dev_sh
  [ -f $phd_dev_csh ] && rm -f $phd_dev_csh
  touch $phd_dev_sh
  touch $phd_dev_csh

  cd $tmpdir
  info "Installing findbugs..." 
  unzip -qo $findbugs_name
  local findbugs_folder=findbugs-2.0.2
  mv $findbugs_folder $buildtools_root
  echo "export FINDBUGS_HOME=$buildtools_root/$findbugs_folder" | tee -a $phd_dev_sh
  echo "setenv FINDBUGS_HOME $buildtools_root/$findbugs_folder" | tee -a $phd_dev_csh

  info "Installing forrest..."
  tar -zxf apache-forrest-0.8.tar.gz
  local forrest_folder=apache-forrest-0.8
  # change it to 777 as the build script may write some file to this folder
  chmod -R 777 $forrest_folder
  mv $forrest_folder $buildtools_root
  echo "export ENV_FORREST_HOME=$buildtools_root/$forrest_folder" | tee -a $phd_dev_sh
  echo "setenv ENV_FORREST_HOME $buildtools_root/$forrest_folder" | tee -a $phd_dev_csh
  
  tar -xzf apache-forrest-0.9-dependencies.tar.gz
  tar -xzf apache-forrest-0.9-sources.tar.gz
  local forrest_folder=apache-forrest-0.9
  # change it to 777 as the build script may write some file to this folder
  chmod -R 777 $forrest_folder
  mv $forrest_folder $buildtools_root
  echo "export ENV_FORREST9_HOME=$buildtools_root/$forrest_folder" | tee -a $phd_dev_sh
  echo "setenv ENV_FORREST9_HOME $buildtools_root/$forrest_folder" | tee -a $phd_dev_csh

  info "Installing JDK7..."
  tar -xvf jdk-7u15-linux-x64.tar
  local jdk_folder=jdk1.7.0_15
  mv $jdk_folder $buildtools_root
  echo "export JAVA7_HOME=$buildtools_root/$jdk_folder" | tee -a $phd_dev_sh
  echo "setenv JAVA7_HOME $buildtools_root/$jdk_folder" | tee -a $phd_dev_csh

  info "Installing JDK6..."
  chmod +x jdk-6u45-linux-x64.bin
  $tmpdir/jdk-6u45-linux-x64.bin
  jdk_folder=jdk1.6.0_45 
  mv $jdk_folder $buildtools_root
  echo "export JAVA6_HOME=$buildtools_root/$jdk_folder" | tee -a $phd_dev_sh
  echo "setenv JAVA6_HOME $buildtools_root/$jdk_folder" | tee -a $phd_dev_csh

  info "Installing JDK5..."
  tar -xzf jdk1.5.0_22-linux-amd64.tar.gz
  jdk_folder=jdk1.5.0_22
  mv $jdk_folder $buildtools_root
  echo "export JAVA5_HOME=$buildtools_root/$jdk_folder" | tee -a $phd_dev_sh
  echo "setenv JAVA5_HOME $buildtools_root/$jdk_folder" | tee -a $phd_dev_csh

  info "Installing ANT 1.8.4 ..."
  local ant_folder=apache-ant-1.8.4
  tar -C $buildtools_root -xzf apache-ant-1.8.4-bin.tar.gz 
  echo "export ANT_HOME=$buildtools_root/$ant_folder" | tee -a $phd_dev_sh
  echo "setenv ANT_HOME $buildtools_root/$ant_folder" | tee -a $phd_dev_csh

  info "Installing ANT 1.7.1 ..."
  local ant_folder=apache-ant-1.7.1
  tar -C $buildtools_root -xzf apache-ant-1.7.1-bin.tar.gz 
  echo "export ANT_HOME17=$buildtools_root/$ant_folder" | tee -a $phd_dev_sh
  echo "setenv ANT_HOME17 $buildtools_root/$ant_folder" | tee -a $phd_dev_csh

  info "Installing MAVEN..."
  local mvn_folder=apache-maven-3.0.5
  tar -C $buildtools_root -xzf apache-maven-3.0.5-bin.tar.gz 
  echo "export MAVEN_HOME=$buildtools_root/$mvn_folder" | tee -a $phd_dev_sh
  echo "setenv MAVEN_HOME $buildtools_root/$mvn_folder" | tee -a $phd_dev_csh

  info "Installing snappy..."
  tar -xzf snappy-1.1.0.tar.gz
  (cd $tmpdir/snappy-1.1.0; ./configure; make; make install) || die "Failed to insall snappy."
  
  info "Installing protocol buffers 2.4.1... "
  tar -xzf protobuf-2.4.1.tar.gz
  local protobuf_folder=/usr/local/protobuf-2.4.1
  (cd protobuf-2.4.1; ./configure --prefix=$protobuf_folder --disable-shared; make; make install;) || die "Failed to install protobuf 2.4.1."
  echo "export ENV_PROTOC_BUF24_HOME=$protobuf_folder" | tee -a $phd_dev_sh
  echo "setenv ENV_PROTOC_BUF24_HOME $protobuf_folder" | tee -a $phd_dev_csh

  info "Installing protocol buffers 2.5.0... "
  tar -xzf protobuf-2.5.0.tar.gz
  local protobuf_folder=/usr/local/protobuf-2.5.0
  (cd protobuf-2.5.0; ./configure --prefix=$protobuf_folder --disable-shared; make; make install;) || die "Failed to install protobuf 2.5.0."
  echo "export ENV_PROTOC_BUF25_HOME=$protobuf_folder" | tee -a $phd_dev_sh
  echo "setenv ENV_PROTOC_BUF25_HOME $protobuf_folder" | tee -a $phd_dev_csh

  info "Installing xerces-c..."
  tar -xzf xerces-c_2_8_0-x86_64-linux-gcc_3_4.tar.gz
  xerces_folder=xerces-c_2_8_0-x86_64-linux-gcc_3_4
  cp -r $tmpdir/$xerces_folder /$buildtools_root
  echo "export XERCESC_HOME=$buildtools_root/$xerces_folder" | tee -a $phd_dev_sh
  echo "setenv XERCESC_HOME $buildtools_root/$xerces_folder" | tee -a $phd_dev_csh

  info "Installing p4..."
  local bin_folder=/usr/bin
  [ ! -d $bin_folder ] && mkdir -p $bin_folder
  cp p4 $bin_folder
  chmod a+x $bin_folder/p4

  # set JAVA_HOME to Java7
  echo "export JAVA_HOME=\$JAVA7_HOME" | tee -a $phd_dev_sh
  echo "setenv JAVA_HOME \$JAVA7_HOME" | tee -a $phd_dev_csh
  
  # set the path variable
  echo "export PATH=\$JAVA7_HOME/bin:\$ANT_HOME/bin:\$MAVEN_HOME/bin:\$PATH" | tee -a $phd_dev_sh
  echo "setenv PATH \$JAVA7_HOME/bin:\$ANT_HOME/bin:\$MAVEN_HOME/bin:\$PATH" | tee -a $phd_dev_csh
}

function printUsageAndExit
{
  echo "This script help you setup Pivotal HD build environment on a 64-bit CentOS Linux."
  echo "Usage: $0: [--downloadOnly | --installOnly]
        --downloadOnly: only download the required software.
        --installOnly: only install the software which have been downloaded.
        -h: print this help message
        If no argument is given, it downloads and installs all the software required."
  echo "Note: this script requires root priviledge."
  echo "Report bug to: mshi@gopivotal.com"
  exit 1
}

# main - here we begin
[ ! -f $common_func ] && echo "Error: File $common_func does not exists." && exit 1
. $common_func

[ ! -f /etc/centos-release ] && die "This is not a CentOS Linux."
uname -a | grep x86_64 > /dev/null 2>&1
[ $? -ne 0 ] && die "This is not a 64bit machine." 

# mark the start time
starttime_sec=$(date +%s)

# make folders
[ ! -d $tmpdir ] && mkdir -p $tmpdir
[ ! -d $buildtools_root ] && mkdir -p $buildtools_root

do_download=true
do_install=true
while [ $# -gt 0 ]
do
  case $1 in 
   '--downloadOnly')
     shift 1;
     do_install=false;;
   '--installOnly')
     shift 1;
     do_download=false;;
   '-h'|'--help')
     shift 1;
     printUsageAndExit;;
   *) error "Invalid command $1." 
      printUsageAndExit;;
  esac
done

[ $do_download == true ] && download
[ $do_install == true ] && install

complete
