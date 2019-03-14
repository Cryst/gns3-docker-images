# FRRouting protocol suite, see https://frrouting.org/

FROM ehlers/ipterm-base

RUN set -e -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y --no-install-recommends install apt-transport-https \
    && echo "deb [trusted=yes] https://deb.frrouting.org/frr stretch frr-stable" > /etc/apt/sources.list.d/frr.list \
    && apt-get update \
    && apt-get -y --no-install-recommends install frr \
    && rm -rf /var/lib/apt/lists/* \
#
# setup FRR
#
    && sed -i 's|^log.*|log file /var/log/frr/frr.log informational|' /etc/frr/frr.conf \
    && printf '\
\043!/bin/sh\n\
\n\
if grep -E "^ *[a-z].*= *(yes|true|[1-9])" /etc/frr/daemons | grep -q -v "^ *vtysh_enable"; then\n\
	service frr start\n\
else\n\
	echo\n\
	echo "Edit /etc/frr/daemons to activate the needed FRR daemons,"\n\
	echo "then start FRR with \"service frr start\"."\n\
fi\n\
echo\n\
\n\
cd /etc/frr\n\
exec bash -i\n' \
        > /etc/init.sh && chmod +x /etc/init.sh

VOLUME [ "/root", "/etc/frr" ]
CMD [ "/etc/init.sh" ]
