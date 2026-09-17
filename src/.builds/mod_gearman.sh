#!/usr/bin/bash

set -eu

export PKG_CONFIG_PATH="$(pwd)/../naemon-core"
export C_INCLUDE_PATH="$(pwd)/../naemon-core:$(pwd)/../naemon-core/src"

#LIBGEARMAN=/omd/versions/default
LIBGEARMAN="$(pwd)/../gearmand/dest"

export CFLAGS="-fsanitize=address"
export LDFLAGS="-fsanitize=address"

OPTS="--with-gearman=$LIBGEARMAN --enable-debug --enable-asan"

./autogen.sh $OPTS
./configure  $OPTS
make
