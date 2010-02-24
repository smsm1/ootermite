#!/bin/bash

# read config
. ../../steps.config

if [ -n "$ccdatapath" ]; then

        if [ ! -d "$ccdatapath/ccache" ];then mkdir -p "$ccdatapath/ccache"; fi
        export CCACHE_DIR=$ccdatapath/ccache
        ccache -M 6G
        ccache -F 300000
        if [ -n "$USE_PCH" ]; then
                 unset USE_PCH
        #        export USE_PCH
        fi
        if [ -z "$CC" -o -z "$CXX" ]
        then
          echo please set environment variables \$CXX and \$CC
          exit 1
        fi
#TODO handle CC and CXX without full path
        if [ -L "$CXX" -a -L "$CC" -a `ls -l "$CXX" "$CC" 2>&1| grep ccache | wc -l` -eq 2 ]; then
          echo Using symlinked ccache from system
        elif [ "$ccUsePrivateSymlinks" == "TRUE" ]; then
          ccbase=`basename $CC`
          cxxbase=`basename $CXX`
          mydir=`pwd`

          if [ ! -d ../ccacheSymLinks ]; then
            # create private symlinks
            mkdir ../ccacheSymLinks
            cd ../ccacheSymLinks
            ln -s `which ccache` $ccbase
            ln -s `which ccache` $cxxbase
            basedir=`pwd`
            cd $mydir
            # check if compilers are found in PATHa
            if [ $CC != `which $ccbase` -a $CC != $ccbase ]; then
              echo "$CC has to be found as $ccbase in PATH"
              exit 1
            fi
            if [ $CXX != `which $cxxbase` -a $CXX != $cxxbase ]; then
              echo "$CXX has to be found as $cxxbase in PATH"
              exit 1
            fi
          else
            cd ../ccacheSymLinks
            basedir=`pwd`
            cd $mydir
          fi
          # set new variables
          CC=$basedir/$ccbase
          CXX=$basedir/$cxxbase
        else
          if [ -n "$WRAPCMD" ]; then
            export CC="$WRAPCMD ccache $CC"
            export CXX="$WRAPCMD ccache $CXX"
          else
            export CC="ccache $CC"
            export CXX="ccache $CXX"
          fi
        fi

#       if windows most likely deprecated
        # disable warning that happens with -E
        # only
#         export ENVCFLAGS="$ENVCFLAGS -wd4668"

else
        echo usage
        echo set ccdatapath in steps.config to enable ccache
fi

