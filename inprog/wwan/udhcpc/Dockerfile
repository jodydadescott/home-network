FROM fedora:latest
WORKDIR /
MAINTAINER jodyscott

RUN dnf -y update
RUN dnf install -y gcc make git

RUN mkdir /build
RUN git clone git://git.busybox.net/udhcp /build
RUN cd /build && make
