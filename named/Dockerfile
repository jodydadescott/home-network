FROM fedora:latest
WORKDIR /
LABEL author=jodyscott

RUN dnf -y update

# Base
RUN dnf install -y iproute iputils bind-utils file hostname procps iptables net-tools dnf-plugins-core tcpdump findutils which 

# ISC Named Server
RUN dnf -y install bind

RUN rm -rf /etc/named

RUN dig +bufsize=1200 +norec NS . @a.root-servers.net > "/etc/named.ca"

RUN dnf clean all

RUN rm -rf /usr/share/named && mkdir -p /usr/share/named
ADD make-example-config /usr/share/named/make-example-config
RUN chmod +x /usr/share/named/make-example-config
ADD docker-compose.yaml.example /usr/share/cloudflared/docker-compose.yaml.example
RUN chmod 644 /usr/share/cloudflared/docker-compose.yaml.example

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
