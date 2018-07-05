# BIRD routing daemon, see http://bird.network.cz

FROM debian:stretch-slim

RUN set -ex \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
#
# download, compile and install bird v2
#
    && apt-get -y --no-install-recommends install libreadline7 \
    && dpkg-query -f '${binary:Package}\n' -W | sort > base_packages \
    && apt-get -y --no-install-recommends install \
        curl gcc libc6-dev make bison flex libncurses-dev libreadline-dev \
    && curl -s -S ftp://bird.network.cz/pub/bird/bird-2.0.2.tar.gz | tar xz \
    && cd bird* \
    && ./configure --sysconfdir='/etc/bird'\
    && make \
    && strip -s bird* \
    && make install \
    && cd .. \
    && rm -rf bird* \
    && dpkg-query -f '${binary:Package}\n' -W | sort > packages \
    && apt-get -y purge \
        `comm -13 base_packages packages` \
    && rm -f base_packages packages \
#
# install remaining tools
#
    && apt-get -y --no-install-recommends install \
        net-tools iproute2 ifupdown isc-dhcp-client inetutils-ping \
        telnet traceroute procps nano vim-tiny \
    && rm -rf /var/lib/apt/lists/* \
#
# setup BIRD
#
    && /bin/echo -e '\
\x23!/bin/sh\n\
\n\
bird\n\
cd /etc/bird\n\
exec bash -i' \
        > /etc/init.sh && chmod +x /etc/init.sh \
    && /bin/echo -e '\
\x23!/usr/bin/awk -f\n\
\n\
BEGIN {\n\
	if (ARGC < 3 || ARGC > 4) {\n\
		print "Usage: create_routes <start IP> <count> [<output file>]"\n\
		exit 1\n\
	}\n\
\n\
	split(ARGV[1], ip, ".")\n\
	ip[1] += 0; ip[2] += 0; ip[3] += 0; ip[4] += 0\n\
	cnt = ARGV[2]\n\
	out = "/dev/stdout"\n\
	if (ARGC > 3) out = ARGV[3]\n\
\n\
	while (--cnt >= 0) {\n\
		print "route " ip[1] "." ip[2] "." ip[3] "." ip[4] "/32 unreachable;" > out\n\
\n\
		for (i=4; i>0 && ++ip[i] >= 256; i--)\n\
			ip[i] = 0\n\
	}\n\
}' \
        > /usr/local/bin/create_routes && chmod +x /usr/local/bin/create_routes

VOLUME [ "/etc/bird" ]
CMD [ "/etc/init.sh" ]
