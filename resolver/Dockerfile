FROM alpine:latest
WORKDIR /
MAINTAINER jodyscott

RUN apk update

# Generic
RUN apk add bash curl bind-tools

# Specific
RUN apk add bind

RUN dig +bufsize=1200 +norec NS . @a.root-servers.net > /etc/named.ca
ADD named.conf /etc/named.conf
RUN chmod 644 /etc/named.conf

ADD entrypoint.sh /
RUN chmod 755 /entrypoint.sh

RUN mkdir -p /usr/share/docker
ADD docker-compose.yaml /usr/share/docker
RUN chmod 644 /usr/share/docker/docker-compose.yaml

CMD ["/entrypoint.sh"]
