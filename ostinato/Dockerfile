# docker image for ostinato

FROM debian:buster-slim

COPY ostinato*.deb /tmp/

RUN set -e -x \
#
# install ostinato
#
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y upgrade \
    && echo 'wireshark-common wireshark-common/install-setuid boolean false' | debconf-set-selections \
    && apt-get -y --no-install-recommends install \
        dumb-init /tmp/ostinato*.deb wireshark tshark \
        dillo ca-certificates lxterminal jwm menu mousepad wmctrl \
        net-tools iproute2 ifupdown iputils-ping \
        telnet traceroute procps nano vim-tiny \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /usr/bin/dillo /usr/local/bin/firefox \
#
# customize jwm menu
#
    && printf '\
?package(ostinato):\\\n\
 needs="x11"\\\n\
 section="Applications"\\\n\
 title="Ostinato"\\\n\
 command="ostinato > /var/log/ostinato.log 2>&1"\n' \
        > /etc/menu/ostinato \
    && printf '\
?package(wireshark):\\\n\
 needs="x11"\\\n\
 section="Applications"\\\n\
 title="Wireshark"\\\n\
 command="wireshark"\n' \
        > /etc/menu/wireshark \
    && printf '\
?package(mousepad):\\\n\
 needs="x11"\\\n\
 section="Applications/TextEditor"\\\n\
 title="Mousepad"\\\n\
 command="mousepad"\n' \
        > /etc/menu/mousepad \
    && echo "postrun=\"sed -i '/^    </ d' debian-menu\"" >> /etc/menu-methods/jwm \
    && sed -i 's/\(Desktops width\)="[0-9]*"/\1="2"/' /etc/jwm/system.jwmrc \
    && sed -i 's/xterm/x-terminal-emulator/g' /etc/jwm/system.jwmrc \
    && update-menus \
#
# start drone only when not already active
#
    && mv /usr/bin/drone /usr/bin/drone.real \
    && printf '\
\043!/bin/sh\n\
\n\
port=7878\n\
while getopts '\'':dhvp:'\'' opt; do\n\
	case "$opt" in\n\
	    p)   port="$OPTARG" ;;\n\
	    d)   ;;\n\
	    *)   exec "${0#-}.real" "$@" ;;\n\
	esac\n\
done\n\
\n\
exec flock -n -E 0 -F "/var/lock/drone.$port" "${0#-}.real" "$@"\n' \
        > /usr/bin/drone && chmod +x /usr/bin/drone \
#
# configure ostinato drone
#
    && mkdir -p /root/.config/Ostinato \
    && printf '\
[General]\n\
RateAccuracy=Low\n\
[PortList]\n\
Exclude=any,lo*\n' \
        > /root/.config/Ostinato/drone.ini \
#
# configure wireshark
#
    && sed -i 's/^disable_lua *=.*/disable_lua = true/' /etc/wireshark/init.lua  \
#
# set lxterminal defaults
#
    && mkdir -p /root/.config/lxterminal \
    && printf '\
[general]\n\
scrollback=1000\n\
fgcolor=#ffffff\n' \
        > /root/.config/lxterminal/lxterminal.conf \
#
# startup script
#
    && printf '\
\043!/bin/sh\n\
[ $$ -eq 1 ] && exec dumb-init -- "$0" "$@"\n\
\n\
\043 disable ostinato update, makes no sense in this environment\n\
grep -q -w -F update.ostinato.org /etc/hosts || \\\n\
	printf "\\n# disable ostinato update\\n127.0.0.127\\tupdate.ostinato.org\\n" >> /etc/hosts\n\
\n\
\043 on unconfigured GNS3 interfaces disable IPv6, set MTU to 9000\n\
if [ -n "$GNS3_MAX_ETHERNET" ]; then\n\
	sed -n '\''s/^ *\\(eth[0-9]*\\):.*/\\1/p'\'' /proc/net/dev | sort > /tmp/netdev\n\
	sed -n '\''s/^iface  *\\(eth[0-9]*\\).*/\\1/p'\'' /etc/network/interfaces | sort -u > /tmp/confdev\n\
	comm -13 /tmp/confdev /tmp/netdev | while read -r DEVICE; do\n\
		ip link set dev "$DEVICE" down\n\
		sysctl -q -w "net.ipv6.conf.${DEVICE}.disable_ipv6=1"\n\
		ip link set dev "$DEVICE" mtu 9000\n\
		ip link set dev "$DEVICE" up\n\
	done\n\
	rm /tmp/confdev /tmp/netdev\n\
	sleep 0.5\n\
fi\n\
\n\
\043 workaround: sometimes the first start of an X application fails\n\
lxterminal -e true 2> /dev/null\n\
\n\
cd\n\
export SHELL=/bin/bash\n\
\n\
\043 start drone\n\
drone < /dev/null > /var/log/ostinato-drone.log 2>&1 &\n\
\n\
\043 start ostinato\n\
ostinato > /var/log/ostinato.log 2>&1 &\n\
\n\
\043 start a windows manager if none is active\n\
wmctrl -m > /dev/null 2>&1 && wait $! || jwm\n' \
        > /etc/init.sh && chmod +x /etc/init.sh

VOLUME [ "/root" ]
CMD [ "/etc/init.sh" ]
