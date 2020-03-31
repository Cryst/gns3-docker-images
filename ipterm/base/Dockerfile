# docker base image for basic networking tools

FROM debian:buster-slim

RUN set -e -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
        curl ca-certificates \
#
# install mtools (msend & mreceive)
#
    && curl -f -s -S -L -o /usr/local/bin/msend https://git.bernhard-ehlers.de/ehlers/mtools/releases/download/v2.3/msend_linux_amd64.bin \
    && curl -f -s -S -L -o /usr/local/bin/mreceive https://git.bernhard-ehlers.de/ehlers/mtools/releases/download/v2.3/mreceive_linux_amd64.bin \
    && chown root:root /usr/local/bin/msend /usr/local/bin/mreceive \
    && chmod 755 /usr/local/bin/msend /usr/local/bin/mreceive \
#
# install remaining tools
#
    && apt-get -y --no-install-recommends install \
        dumb-init iperf3 knot-host mtr-tiny openssh-client socat tcpdump \
        net-tools iproute2 ifupdown inetutils-ping \
        telnet traceroute procps nano vim-tiny \
    && ln -s /usr/bin/khost /usr/local/bin/host \
    && rm -rf /var/lib/apt/lists/*
