#!/bin/bash

set -e

[ -n "${NEXTDNS_ID}" ] &&  NEXTDNS_ARGUMENTS+=" -config ${NEXTDNS_ID}"

./nextdns run ${NEXTDNS_ARGUMENTS}
