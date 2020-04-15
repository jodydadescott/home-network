FROM alpine:latest
WORKDIR /
MAINTAINER jodyscott

RUN apk update

# Generic
RUN apk add bash curl bind-tools

# Specific
RUN apk add nginx nginx-mod-stream certbot certbot-nginx

RUN mv /etc/nginx /usr/share
RUN mkdir -p /etc/nginx

RUN mkdir -p /usr/share/this
ADD docker-compose.yaml /usr/share/this
ADD nginx.conf /usr/share/this
ADD readme /usr/share/this

ADD entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

CMD ["/entrypoint.sh"]
