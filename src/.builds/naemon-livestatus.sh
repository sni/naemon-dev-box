#!/usr/bin/bash

set -eu

export CFLAGS="-g -O0 -fsanitize=address -fno-omit-frame-pointer"

autoreconf -s -i
automake --add-missing
export NAEMON_LIBS=$(PKG_CONFIG_PATH=../naemon-core/ pkg-config --libs naemon-uninstalled)
export NAEMON_CFLAGS=$(PKG_CONFIG_PATH=../naemon-core/ pkg-config --cflags naemon-uninstalled)
./configure
make
