FROM alpine:latest
WORKDIR /
MAINTAINER jodyscott

RUN apk update

# Generic
RUN apk add bash curl bind-tools

RUN mkdir -p /dynamicdns

ADD dynamicdns_daemon /dynamicdns/
ADD get_arecord_ip /dynamicdns/
ADD get_known_ip /dynamicdns/
ADD update_arecord /dynamicdns/

RUN chmod 755 /dynamicdns/dynamicdns_daemon /dynamicdns/get_arecord_ip
RUN chmod 755 /dynamicdns/get_known_ip /dynamicdns/update_arecord

ADD lib.dynamicdns /dynamicdns/
RUN chmod 644 /dynamicdns/lib.dynamicdns

CMD ["/dynamicdns/dynamicdns_daemon"]
