FROM fedora:latest
WORKDIR /
LABEL author=jodyscott

RUN dnf -y update

# Base
RUN dnf install -y iproute iputils bind-utils file hostname procps iptables net-tools dnf-plugins-core tcpdump findutils which 

RUN dnf clean all

RUN mkdir -p /usr/share/ddu
ADD docker-compose.yaml.example /usr/share/ddu/docker-compose.yaml.example
RUN chmod 644 /usr/share/ddu/docker-compose.yaml.example

ADD ddu /usr/local/sbin/ddu
RUN chmod +x /usr/local/sbin/ddu

CMD ["/usr/local/sbin/ddu"]
