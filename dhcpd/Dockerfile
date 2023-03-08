FROM fedora:latest
WORKDIR /
LABEL author=jodyscott

# Set the service_name
RUN echo dhcpd > /.service_name

RUN dnf -y update

# Base
RUN dnf install -y iproute iputils bind-utils file hostname procps iptables net-tools dnf-plugins-core tcpdump findutils which 

# ISC DHCP Server
RUN dnf -y install dhcp-server

# ISC Named Server - need to be installed so that we have the rndc-confgen utility
RUN dnf -y install bind

RUN dnf clean all
RUN rm -rf /etc/dhcp

ADD make-config /usr/sbin/make-config
RUN chmod +x /usr/sbin/make-config

ADD entrypoint.sh /
RUN chmod 755 /entrypoint.sh

# Remove the named stuff we dont want or need
RUN find ./ -name "*named*" | xargs rm -rf -

RUN dnf clean all

CMD ["/entrypoint.sh"]
