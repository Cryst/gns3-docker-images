#!/bin/sh
#
# Startup script for Open vSwitch
#
# Copyright (C) 2015 GNS3 Technologies Inc.
# Copyright (C) 2019 Bernhard Ehlers
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

cust_init="/etc/openvswitch/init.sh"

export PATH="$PATH:/usr/share/openvswitch/scripts"

if [ ! -f "/etc/openvswitch/conf.db" ]; then
	# init database and start the daemons
	cat /proc/sys/kernel/random/uuid > /etc/openvswitch/system-id.conf
	ovs-ctl --system-id=random start

	# add bridges br0..br3
	x=0
	while [ $x -lt 4 ]; do
		ovs-vsctl add-br br$x
		ovs-vsctl set bridge br$x datapath_type=netdev
		x=$((x+1))
	done

	# add eth interfaces without network configuration to br0
	sed -n 's/^ *\(eth[0-9]*\):.*/\1/p' /proc/net/dev | while read -r if; do
		ofport=${if#eth}
		[ "$ofport" -eq 0 ] && ofport=1000
		grep -q -s -E \
		     "^[[:blank:]]*iface[[:blank:]]+${if}[[:blank:].:]" \
		     /etc/network/interfaces || \
			ovs-vsctl add-port br0 "$if" -- \
			          set interface "$if" ofport_request="$ofport"
	done
else
	# use existing database and start the daemons
	ovs-ctl --system-id=random start
fi

# activate internal bridge interfaces
ovs-vsctl --bare -f table --columns=name find interface type=internal | while read -r if; do
	ip link set dev "$if" up
done

# configure non-lo/eth interfaces of /etc/network/interfaces
sed -n -E -e '/^[[:blank:]]*iface[[:blank:]]+(lo|eth)/d' \
    -e 's/^[[:blank:]]*iface[[:blank:]]+([a-zA-Z][^[:blank:]]*).*/\1/p' \
    /etc/network/interfaces | \
while read -r if; do
	ifup -f "$if"
done

# run custom initialization script
[ -f "$cust_init" ] && [ -x "$cust_init" ] && "$cust_init"
