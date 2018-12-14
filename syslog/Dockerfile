FROM debian:stretch-slim

RUN set -e -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
        dumb-init rsyslog lnav \
        net-tools iproute2 ifupdown isc-dhcp-client inetutils-ping \
        telnet traceroute procps nano vim-tiny \
    && rm -rf /var/lib/apt/lists/* \
#
# rsyslog configuration
#
    && sed -i.orig -E -e '/imudp|imtcp/ s/^#//' -e '/^[^#].*klog/ s/^/#/' /etc/rsyslog.conf \
    && printf '\
\043\n\
\043 Logging from network devices\n\
\043\n\
if not ($fromhost-ip startswith "127.") then {\n\
	-/var/log/network\n\
	stop\n\
}\n' \
        > /etc/rsyslog.d/40-network.conf \
#
# logview script
#
    && printf '\
\043!/bin/sh\n\
\n\
\043 skip options\n\
while getopts ":hHI:iuCd:Vartw:c:f:nq" _; do :; done\n\
\n\
if [ $OPTIND -gt $# ]; then\n\
	\043 no arguments, view default logfiles\n\
	lnav "$@" /var/log/syslog /var/log/network\n\
else\n\
	\043 logfiles in command line\n\
	lnav "$@"\n\
fi\n' \
        > /usr/local/bin/logview && chmod +x /usr/local/bin/logview \
#
# startup script
#
    && printf '\
\043!/bin/sh\n\
[ $$ -eq 1 ] && exec dumb-init -- "$0" "$@"\n\
\n\
service rsyslog start\n\
[ -e /var/log/network ] || touch /var/log/network\n\
\n\
cd\n\
logview\n\
echo\n\
echo "Use \"logview\" to view the logs."\n\
echo\n\
exec bash -i\n' \
        > /etc/init.sh && chmod +x /etc/init.sh

VOLUME [ "/root", "/var/log" ]
CMD [ "/etc/init.sh" ]
