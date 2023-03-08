FROM fedora:latest
WORKDIR /
LABEL author=jodyscott

RUN dnf -y update

# Base
RUN dnf install -y iproute iputils bind-utils file hostname procps iptables net-tools dnf-plugins-core tcpdump findutils

# Wi-Fi utilities
RUN dnf -y install wpa_supplicant 
# RUN dnf -y install iw

# inotify tools
RUN dnf install -y inotify-tools

# Git
RUN dnf -y install git

# Docker utilties (for managing Docker host from within container)
RUN dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
RUN dnf -y install docker-ce-cli containerd.io

ADD entrypoint.sh /
RUN chmod 755 /entrypoint.sh

ADD test /test
RUN chmod +x /test/test.sh

CMD ["/entrypoint.sh"]
