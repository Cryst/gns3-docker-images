# FRRouting protocol suite, see https://frrouting.org/

FROM ehlers/ipterm-base

RUN set -ex \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && curl -s -S -L -o /tmp/frr.deb https://github.com/FRRouting/frr/releases/download/frr-4.0/frr_4.0-1.debian9.1_amd64.deb \
    && apt-get -y --no-install-recommends install /tmp/frr.deb \
    && rm /tmp/frr.deb \
    && ln -s /usr/lib/frr/frr /etc/init.d/frr \
    && rm -rf /var/lib/apt/lists/* \
#
# setup FRR
#
    && sed -i 's%^log.*%log file /var/log/frr/frr.log informational%' /etc/frr/frr.conf \
    && /bin/echo -e '\
\x23!/bin/sh\n\
\n\
if grep -q -E "^ *[a-z].*= *(yes|true|[1-9])" /etc/frr/daemons; then\n\
	service frr start\n\
else\n\
	echo\n\
	echo "Edit /etc/frr/daemons to activate the needed FRR daemons,"\n\
	echo "then start FRR with \"service frr start\"."\n\
fi\n\
echo\n\
\n\
cd /etc/frr\n\
exec bash -i' \
        > /etc/init.sh && chmod +x /etc/init.sh

VOLUME [ "/root", "/etc/frr" ]
CMD [ "/etc/init.sh" ]
