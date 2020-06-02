# FRRouting protocol suite, see https://frrouting.org/

FROM ehlers/ipterm-base

RUN set -e -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y --no-install-recommends install apt-transport-https \
    && echo "deb [trusted=yes] https://deb.frrouting.org/frr buster frr-stable" > /etc/apt/sources.list.d/frr.list \
    && apt-get update \
    && apt-get -y --no-install-recommends install frr less \
    && rm -rf /var/lib/apt/lists/* \
#
# setup FRR
#
    && sed -i '/^ *\(bgp\|ospf\|ospf6\|rip\|ripng\)d *=/ s/=.*/=yes/' /etc/frr/daemons \
    && sed -i 's|^\(log.*\)|#\1\nlog file /var/log/frr/frr.log informational|' /etc/frr/frr.conf \
    && printf '\nexport VTYSH_PAGER="less -M -i -EFX"\n' >> /root/.profile \
    && printf '\ncd /etc/frr\nvtysh\n' >> /root/.profile \
#
# startup script
#
    && printf '\
\043!/bin/sh\n\
[ $$ -eq 1 ] && exec dumb-init -r 15:1 -- "$0" "$@"\n\
\n\
sysctl -q net.ipv6.conf.all.forwarding=1\n\
/usr/lib/frr/watchfrr.sh start all\n\
sleep 1\n\
service frr start\n\
\n\
exec bash -i -l\n' \
        > /etc/init.sh && chmod +x /etc/init.sh

VOLUME [ "/root", "/etc/frr" ]
CMD [ "/etc/init.sh" ]
