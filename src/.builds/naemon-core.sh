#!/usr/bin/bash

set -eu

export CFLAGS="-g -O0 -fsanitize=address -fno-omit-frame-pointer"

./autogen.sh
make
