#!/bin/bash

function main() {

  # shellcheck disable=SC2015
  [[ "$CLOUDFLARED_PORT" ]] && {
    err "CLOUDFLARED_PORT is set to $CLOUDFLARED_PORT (env)"
  } || {
    CLOUDFLARED_PORT=4053
    err "CLOUDFLARED_PORT set to $CLOUDFLARED_PORT (default)"
  }

  err "CLOUDFLARED_PORT is $CLOUDFLARED_PORT"

  [[ $CLOUDFLARED_PORT ]] || {
    err "Missing required environment variable CLOUDFLARED_PORT"
    return 2
  }

  sed "s/proxy-dns-port: \$CLOUDFLARED_PORT/proxy-dns-port: $CLOUDFLARED_PORT/g" /etc/cloudflared.in > /etc/cloudflared.conf
  exec /usr/local/sbin/cloudflared --no-autoupdate --config /etc/cloudflared.conf
}

err() { echo "$@" 1>&2; }

main "$@"
