#!/usr/bin/bash

set -eu

# make it writeable for dev user
chgrp dev -R /src/thruk
# clone owner permissions to group
chmod -R g=u /src/thruk

sudo su - dev << END
  set -eu
  cd /src/thruk
  cpanm -n File::ChangeNotify
  perl Makefile.PL
  make
  make themes
END

