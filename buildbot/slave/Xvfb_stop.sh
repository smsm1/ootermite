#!/bin/bash
# find the named process(es)
findproc() {
  pid=`/bin/ps -ef |
  /bin/grep -w "$1" |
  /bin/grep -v grep |
  /bin/grep -v stop |
  /usr/bin/awk '{print $2}'`
  echo $pid
}

# kill the named process(es) (borrowed from S15nfs.server)
killproc() {
   pid=`findproc "$1"`
   [ "$pid" != "" ] && echo killing $pid && kill $pid
}

# for Linux style
killproc "Xvfb :2"

# for Solaris style
killproc "Xsun :2"


# read config
. ../../steps.config

if [ "$XvfbBinary" == "vncserver" ]
then
  echo $XvfbBinary -kill :2
  $XvfbBinary -kill :2
fi


