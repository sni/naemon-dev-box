#!/bin/bash

printf "[%lu] PROCESS_SERVICE_CHECK_RESULT;testhost_0001;check_passive;$1;TEST - $(date)|x=5\n" `date +%s` > $OMD_ROOT/tmp/run/naemon.cmd
