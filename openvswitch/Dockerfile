# Open vSwitch

FROM alpine

ADD ovs_init.sh /etc/

RUN set -e -x -o pipefail \
#
# install openvswitch and dumb-init, nano, nodnsd
#
    && apk --no-cache add dumb-init nano \
       openvswitch openvswitch-doc mdocml less \
    && mkdir -p /usr/local/sbin \
    && wget -q -O /usr/local/sbin/nodnsd https://git.bernhard-ehlers.de/ehlers/nodnsd/releases/download/v0.1/nodnsd_linux_amd64.bin \
    && chmod 755 /usr/local/sbin/nodnsd \
#
# startup script
#
    && chmod +x /etc/ovs_init.sh \
    && printf '\
\043!/bin/sh\n\
[ $$ -eq 1 ] && exec dumb-init -r 15:1 -- "$0" "$@"\n\
\n\
nodnsd\n\
\n\
export PATH="$PATH:/usr/share/openvswitch/scripts"\n\
export LESS="-M -i"\n\
export PAGER="less -s"\n\
\n\
/etc/ovs_init.sh\n\
\n\
if [ $# -gt 0 ]; then\n\
	exec "$@"\n\
else\n\
	cd; exec ash -i\n\
fi\n' \
       > /etc/init.sh && chmod +x /etc/init.sh

ENTRYPOINT [ "/etc/init.sh" ]
VOLUME [ "/root", "/etc/openvswitch" ]