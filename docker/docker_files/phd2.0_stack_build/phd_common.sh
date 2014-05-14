#----------------------------------------------------------------------
# Copyright (c) 2013 - , Pivotal All Rights Reserved
#----------------------------------------------------------------------
#
#----------------------------------------------------------------------
# Description: this script contains command shell functions
# Author: Mingjiang Shi
#
#
# Revision History
# 2013/07/15 - Mingjiang Shi - initial creation
DATE_FMT="%m/%d %H:%M:%S"
RPM_DEPENDENCIES="gcc gcc-c++ cppunit-devel fuse-devel lzo-devel cmake zlib-devel bzip2-devel openssl-devel check check-devel libtool rpm-build redhat-rpm-config asciidoc xmlto ruby make fuse git"
#----------------------------------------------------------------------
# Print an information message
# $@ - the message to be printed
#----------------------------------------------------------------------
function info
{
  echo "[`date +"$DATE_FMT"`] [Info] - $@"
}

#----------------------------------------------------------------------
# Print an error message
# $@ - the message to be printed
#----------------------------------------------------------------------
function error
{
  echo "[`date +"$DATE_FMT"`] [Error] - $@"
}

#----------------------------------------------------------------------
# Print an warning message
# $@ - the message to be printed
#----------------------------------------------------------------------
function warn
{
  echo "[`date +"$DATE_FMT"`] [Warning] - $@"
}

#----------------------------------------------------------------------
# Print an message and exit
# $@ - the message to be printed
#----------------------------------------------------------------------
function die
{
  error $@;
  exit 1;
}

function complete
{
  local endtime_sec=$(date +%s)
  echo "[`date +"$DATE_FMT"`] Completed - time taken: $(print_time_diff $(( $endtime_sec - $starttime_sec )))"
}

function print_time_diff()
{
  if [[ $1 -lt 60 ]]; then
    echo "$1 secs"
  else
    local diff_in_min=$(( $1 / 60 ))
    local diff_in_secs=$(( $1 % 60 ))
    echo -ne "$diff_in_min mins"
    if [[ $diff_in_secs -ne 0 ]];then
      echo -ne " $diff_in_secs secs"
    fi
    echo
  fi
}
