FROM fedora:29
WORKDIR /
MAINTAINER jodyscott

RUN dnf -y update

# Generic
RUN dnf -y install bind-utils procps findutils file which hostname

# Specific
RUN dnf -y install asterisk asterisk-pjsip
# pjproject

RUN mv /etc/asterisk /usr/share/asterisk_template
RUN mkdir -p /etc/asterisk

ADD cli /usr/bin/cli
RUN chmod +x /usr/bin/cli

RUN rm -rf /usr/lib64/asterisk/modules/res_ari_mailboxes.so

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]
