FROM fedora:latest
WORKDIR /
LABEL author=jodyscott

RUN dnf -y update

# Set the service_name
RUN echo sshd > /.service_name

# Base
RUN dnf install -y iproute iputils bind-utils file hostname procps iptables net-tools dnf-plugins-core tcpdump findutils which 

# SSHD
RUN dnf install -y openssh-server passwd

# SSH Client
RUN dnf -y install openssh-clients

# Wi-Fi utilities
RUN dnf -y install wpa_supplicant 
RUN dnf -y install iw

# WWAN Utilties
RUN dnf -y install libqmi-utils

# Git
RUN dnf -y install git

# Docker utilties (for managing Docker host from within container)
RUN dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
RUN dnf -y install docker-ce-cli containerd.io

RUN curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Speed check utility
RUN curl -L https://github.com/ddo/fast/releases/download/v0.0.4/fast_linux_amd64 -o /usr/bin/fast
RUN chmod +x /usr/bin/fast

RUN useradd admin
RUN usermod -a -G wheel admin
RUN usermod -a -G docker admin
RUN rm -rf /etc/sudoers

ADD entrypoint.sh /
RUN chmod 755 /entrypoint.sh

RUN rm -rf /etc/ssh

ADD make-config /usr/sbin/make-config
RUN chmod +x /usr/sbin/make-config

RUN echo "Defaults    secure_path = /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/var/lib/snapd/snap/bin" > /etc/sudoers
RUN echo "root	ALL=(ALL) 	ALL" >> /etc/sudoers
RUN echo "%wheel	ALL=(ALL)	NOPASSWD: ALL" >> /etc/sudoers
RUN chmod 440 /etc/sudoers

RUN dnf clean all

CMD ["/entrypoint.sh"]
