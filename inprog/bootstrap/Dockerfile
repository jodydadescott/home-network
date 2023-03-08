FROM fedora:latest
WORKDIR /
LABEL author=jodyscott

RUN dnf -y update

# Base
RUN dnf install -y iproute iputils bind-utils file hostname procps iptables net-tools dnf-plugins-core tcpdump findutils which 

# Docker utilties (for managing Docker host from within container)
RUN dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
RUN dnf -y install docker-ce-cli containerd.io

ADD entrypoint.sh /
RUN chmod 755 /entrypoint.sh

RUN mkdir -p /usr/local/share
ADD helper.script /usr/local/share
ADD bootstrap /usr/local/share
ADD containershell.bash /usr/local/share/containershell

CMD ["/entrypoint.sh"]
