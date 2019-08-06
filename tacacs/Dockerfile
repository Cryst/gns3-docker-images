FROM debian:buster-slim

COPY do_auth.py tac_plus.conf.do_auth tac_passwd python*.deb /tmp/

RUN set -e -x \
#
# install tacacs+ server
#
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
        dumb-init /tmp/python*.deb tacacs+ \
        net-tools iproute2 ifupdown isc-dhcp-client inetutils-ping \
        telnet traceroute procps nano vim-tiny \
    && rm -rf /var/lib/apt/lists/* \
#
# update do_auth
#
    && mv /tmp/do_auth.py /usr/sbin/do_auth \
    && chmod +x /usr/sbin/do_auth \
#
# tac_plus.conf template for do_auth
#
    && mv /tmp/tac_plus.conf.do_auth /etc/tacacs+/ \
#
# tacacs utilities
#
    && mv /tmp/tac_passwd /usr/local/sbin/ \
    && chmod 755 /usr/local/sbin/tac_passwd \
    && ln -s tac_passwd /usr/local/sbin/tac_adduser \
    && ln -s tac_passwd /usr/local/sbin/tac_deluser \
    && printf '\
\043!/bin/sh\n\
\n\
tac_plus -C /etc/tacacs+/tac_plus.conf -P\n' \
        > /usr/local/sbin/tac_parse && chmod +x /usr/local/sbin/tac_parse \
    && printf '\
\043!/bin/sh\n\
\n\
service tacacs_plus reload\n' \
        > /usr/local/sbin/tac_reload && chmod +x /usr/local/sbin/tac_reload \
    && printf '\
\043!/bin/sh\n\
\n\
service tacacs_plus start\n' \
        > /usr/local/sbin/tac_start && chmod +x /usr/local/sbin/tac_start \
    && printf '\
\043!/bin/sh\n\
\n\
service tacacs_plus stop\n' \
        > /usr/local/sbin/tac_stop && chmod +x /usr/local/sbin/tac_stop \
    && chown -h root:root /usr/local/sbin/* \
#
# startup script
#
    && printf '\
\043!/bin/sh\n\
[ $$ -eq 1 ] && exec dumb-init -- "$0" "$@"\n\
\n\
service tacacs_plus start\n\
\n\
cd /etc/tacacs+\n\
exec bash -i\n' \
        > /etc/init.sh && chmod +x /etc/init.sh

VOLUME [ "/etc/tacacs+" ]
CMD [ "/etc/init.sh" ]
