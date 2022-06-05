FROM fedora:latest
WORKDIR /
LABEL author=jodyscott

ARG CLOUDFLARED_URI="https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64"

RUN dnf -y update

# Base
RUN dnf install -y iproute iputils bind-utils file hostname procps net-tools dnf-plugins-core tcpdump findutils

RUN curl -L -o /usr/local/sbin/cloudflared $CLOUDFLARED_URI
RUN chmod +x /usr/local/sbin/cloudflared

ADD cloudflared.conf /etc/cloudflared.in
RUN chmod 644 /etc/cloudflared.in

ADD entrypoint.sh /
RUN chmod 755 /entrypoint.sh

CMD ["/entrypoint.sh"]
