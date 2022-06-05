FROM alpine:latest
WORKDIR /
MAINTAINER jodyscott

RUN apk update

# Generic
RUN apk add bash curl bind-tools

# Specific
# RUN apk add

ADD cloudflared.binary /usr/sbin/cloudflared
RUN chmod 755 /usr/sbin/cloudflared

ADD entrypoint.sh /
RUN chmod 755 /entrypoint.sh

CMD ["/entrypoint.sh"]
