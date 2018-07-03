# ethloop - virtual RJ45 loopback plug

FROM debian:stretch-slim

COPY ethloop.c /root/

RUN set -ex \
    && cd /root \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
        libpcap0.8 net-tools \
    && dpkg-query -f '${binary:Package}\n' -W | sort > base_packages \
    && apt-get -y --no-install-recommends install \
        gcc libc6-dev libpcap0.8-dev \
    && gcc -Wall -O2 -s -o /usr/local/bin/ethloop ethloop.c -lpcap \
    && dpkg-query -f '${binary:Package}\n' -W | sort > packages \
    && apt-get -y purge \
        `comm -13 base_packages packages` \
    && rm -f base_packages packages \
    && rm -rf /var/lib/apt/lists/* \
#
# startup script
#
    && /bin/echo -e '\
\x23!/bin/sh\n\
\x23 on eth0 disable IPv6, set MTU to 9000\n\
ifconfig eth0 down\n\
echo 1 > /proc/sys/net/ipv6/conf/eth0/disable_ipv6\n\
ifconfig eth0 mtu 9000 up\n\
\n\
exec ethloop eth0' \
        > /etc/init.sh && chmod +x /etc/init.sh

CMD [ "/etc/init.sh" ]
