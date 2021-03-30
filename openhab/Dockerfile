FROM openhab/openhab:3.0.0.RC1

RUN apt update

RUN apt -y install dnsutils

RUN apt -y install python3 python3-pip
RUN pip3 install bs4
RUN pip3 install pyadtpulse

ADD adt-* /usr/bin/
RUN chmod 755 /usr/bin/adt-arm-away /usr/bin/adt-arm-stay /usr/bin/adt-disarm /usr/bin/adt-status

RUN mkdir -p /usr/share/docker
ADD docker-compose.yaml /usr/share/docker
RUN chmod 644 /usr/share/docker/docker-compose.yaml

ENTRYPOINT ["/entrypoint.sh"]

# Execute command
CMD ["gosu", "openhab", "tini", "-s", "./start.sh"]
