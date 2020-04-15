#!/bin/bash

main() {  exec /usr/sbin/named -fg -c /etc/named.conf; }

err() { echo "$@" 1>&2; }

main $@
