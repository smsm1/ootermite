#!/bin/bash
if [ -n "$1" ]; then

        if [ ! -d "$1/ccache" ];then mkdir -p "$1/ccache"; fi
        export CCACHE_DIR=$1/ccache
        ccache -M 4G
        ccache -F 200000
        if [ -n "$USE_PCH" ]; then
                 unset USE_PCH
        #        export USE_PCH
        fi

        export CC="ccache $CC"
        export CXX="ccache $CXX"

else
        echo usage...
        echo call with directory to enable ccache
fi

