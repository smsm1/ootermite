#!/bin/bash

# read config
. ../../steps.config

if [ -n "$ccdatapath" ]; then

        if [ ! -d "$ccdatapath/ccache" ];then mkdir -p "$ccdatapath/ccache"; fi
        export CCACHE_DIR=$ccdatapath/ccache
        ccache -M 4G
        ccache -F 200000
        if [ -n "$USE_PCH" ]; then
                 unset USE_PCH
        #        export USE_PCH
        fi
        if [ -z "$CC" -o -z "$CXX" ]
        then
          echo please set environment variables \$CXX and \$CC
          exit 1
        fi
        if [ -n "$WRAPCMD" ]; then
          export CC="$WRAPCMD ccache $CC"
          export CXX="$WRAPCMD ccache $CXX"
        else
          export CC="ccache $CC"
          export CXX="ccache $CXX"
        fi

#       if windows most likely deprecated
        # disable warning that happens with -E
        # only
#         export ENVCFLAGS="$ENVCFLAGS -wd4668"

else
        echo usage
        echo set ccdatapath in steps.config to enable ccache
fi

