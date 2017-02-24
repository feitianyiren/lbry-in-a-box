#!/bin/bash

# these commit changes the address prefix in lbryum and lbryum-server
# to be in regtest settings, and are cherry-picked on top of master
LBRYUM_ADDR_PREFIX=adad3604943da278b693ae71a5f317165b1c99b8
LBRYUM_SERVER_ADDR_PREFIX=1ea2f3c56e7f8b8deebcc05292fef787289a3a61

(cd lbrynet/lbryum; git fetch origin; git cherry-pick $LBRYUM_ADDR_PREFIX)
(cd lighthouse/lbryum; git fetch origin; git cherry-pick $LBRYUM_ADDR_PREFIX)
(cd lbryum-server/lbryum-server; git fetch origin; git cherry-pick $LBRYUM_SERVER_ADDR_PREFIX)
