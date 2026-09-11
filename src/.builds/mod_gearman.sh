#!/usr/bin/bash

set -eu

export PKG_CONFIG_PATH="$(pwd)/../naemon-core"
export C_INCLUDE_PATH="$(pwd)/../naemon-core:$(pwd)/../naemon-core/src"

./autogen.sh --with-gearman=/omd/versions/default --enable-debug --enable-asan
./configure --with-gearman=/omd/versions/default --enable-debug --enable-asan
make
