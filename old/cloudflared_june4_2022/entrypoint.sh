#!/bin/bash

main()
{
[[ $CLOUDFLARED_PORT ]] || {
  err "Missing required environment variable CLOUDFLARED_PORT"
  return 2
}
cat <<EOF > /etc/cloudflared.conf || { err "Failed to write conf file"; return 2; }
proxy-dns: true
proxy-dns-port: $CLOUDFLARED_PORT
proxy-dns-upstream:
 - https://1.1.1.1/dns-query
 - https://1.0.0.1/dns-query
EOF
exec /usr/sbin/cloudflared --no-autoupdate --config /etc/cloudflared.conf
}

err() { echo "$@" 1>&2; }

main $@
