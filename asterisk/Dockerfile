FROM fedora:latest
WORKDIR /
LABEL author=jodyscott

RUN dnf -y update

# Base
RUN dnf install -y iproute iputils bind-utils file hostname procps iptables net-tools dnf-plugins-core tcpdump findutils which 

# Specific
RUN dnf -y install asterisk asterisk-pjsip
# pjproject

RUN mv /etc/asterisk /usr/share/asterisk_template

ADD cli /usr/bin/cli
RUN chmod +x /usr/bin/cli

RUN rm -rf /usr/lib64/asterisk/modules/res_ari_mailboxes.so

RUN dnf clean all
