FROM fedora:latest
WORKDIR /
LABEL author=jodyscott

RUN dnf -y update

# Base
RUN dnf install -y iproute iputils bind-utils file hostname procps iptables net-tools dnf-plugins-core tcpdump findutils

# Wi-Fi utilities
RUN dnf -y install wpa_supplicant 
RUN dnf -y install iw

# WWAN Utilties
RUN dnf -y install libqmi-utils

# dhclient
RUN dnf -y install dhcp-client

# Speed check utility
RUN curl -L https://github.com/ddo/fast/releases/download/v0.0.4/fast_linux_amd64 -o /usr/bin/fast
RUN chmod +x /usr/bin/fast

# udhcpc is a dhcp client that supports raw-ip
RUN mkdir -p /usr/share/udhcpc
ADD udhcpc/bin/udhcpc /usr/local/sbin/udhcpc
RUN chmod +x /usr/local/sbin/udhcpc
ADD udhcpc/share/default.script /usr/share/udhcpc/default.script
RUN chmod +x /usr/share/udhcpc/default.script 
ADD udhcpc/share/default.bound /usr/share/udhcpc/default.bound
RUN chmod +x /usr/share/udhcpc/default.bound
ADD udhcpc/share/default.deconfig /usr/share/udhcpc/default.deconfig
RUN chmod +x /usr/share/udhcpc/default.deconfig
ADD udhcpc/share/default.leasefail /usr/share/udhcpc/default.leasefail
RUN chmod +x /usr/share/udhcpc/default.leasefail
ADD udhcpc/share/default.renew /usr/share/udhcpc/default.renew
RUN chmod +x /usr/share/udhcpc/default.renew

ADD verizon/connect /usr/bin/verizon-connect
RUN chmod +x /usr/bin/verizon-connect

ADD entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

RUN rm -rf /usr/sbin/dhclient-script
ADD dhclient-script /usr/sbin/dhclient-script
RUN chmod 755 /usr/sbin/dhclient-script

RUN dnf clean all

CMD ["/entrypoint.sh"]
