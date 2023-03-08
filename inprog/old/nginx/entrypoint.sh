#!/bin/bash

CERTBOT_RENEW_PERIOD_DEFAULT=86400 # 1 Day

main() {

  [[ $CONF_FILE ]] || { err "Required system variable CONF_FILE not set"; return 2; }
  [ -f $CONF_FILE ] || { err "File $CONF_FILE not found"; return 2; }

    [[ $CERTBOT_DOMAINS ]] || { err "Required system variable CERTBOT_DOMAINS not set"; return 2; }

  err "Configuration file is $CONF_FILE"

  [[ $CERTBOT_RENEW_PERIOD ]] && {
    err "Cert renewal set by user"
  } || {
    CERTBOT_RENEW_PERIOD=$CERTBOT_RENEW_PERIOD_DEFAULT;
    err "Cert renewal set to default"
  }

  err "Cert renewal is $CERTBOT_RENEW_PERIOD"

  run=1
	trap run=0 SIGINT SIGTERM

  err "Starting nginx"
  mkdir -p /run/nginx  || { err "Failed to create directory /run/nginx"; return 2; }
  /usr/sbin/nginx || return $?

  err "Sleeping for 2 seconds"
  sleep 2

  err "Renewing certs (on start)"
  renewcerts || return $?

  c=0
	while [ true ]; do
		[ $run -ne 1 ] && { break; }
    [ $c -gt $CERTBOT_RENEW_PERIOD ] && {
      c=0
    err "Renewing certs (periodic)"
      renewcerts || return $?;
    }
    ((c=c+1))
		sleep 1
	done

  err "Shutting down"
  err "Stopping nginx"
  pkill nginx
  err "Goobye"
}

renewcerts() { /usr/bin/certbot renew || return $?; }

err() { echo "$@" 1>&2; }

main $@
