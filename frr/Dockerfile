# FRRouting protocol suite, see https://frrouting.org/

FROM ehlers/ipterm-base

RUN set -ex \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && url=`curl -s -S -L https://api.github.com/repos/FRRouting/frr/releases/latest | sed -n 's/^ *"browser_download_url": "\([^"]*\/frr_[0-9.-]*debian9[0-9.]*_amd64.deb\)".*/\1/p'` \
    && if [ -z "$url" ]; then echo "FRR package for Debian not found" >&2; exit 1; fi \
    && curl -s -S -L -o /tmp/frr.deb "$url" \
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
