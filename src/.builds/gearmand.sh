#!/usr/bin/bash

set -eu

export CFLAGS="-g -O0 -fsanitize=address -fno-omit-frame-pointer -Wno-error"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="-fsanitize=address -fno-omit-frame-pointer"

unset PYTHONPATH
unset LD_LIBRARY_PATH

autoreconf -s -i
./configure \
	--enable-jobserver=no \
	--disable-libmemcached \
	--disable-hiredis \
	--disable-libdrizzle \
	--disable-libpq \
	--disable-libtokyocabinet \
	--without-mysql \
	--prefix=/

# AX_HARDEN_COMPILER_FLAGS appends a trailing -Werror to CFLAGS/CXXFLAGS after
# our -Wno-error (last flag wins for GCC). Neutralize it in the generated
# Makefiles so -Wno-error takes effect.
find . -name Makefile -exec sed -i 's/-Werror/-Wno-error/g' {} +

make -j 1

# using a dest folder which matches existing .gitignore
mkdir -p 'dest~'
make DESTDIR="$(pwd)/dest~" install
