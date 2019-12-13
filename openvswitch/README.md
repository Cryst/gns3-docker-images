# Docker Open vSwitch

This appliance provides an Open vSwitch, it's based on Alpine Linux.
Open vSwitch is documented at <http://docs.openvswitch.org/en/stable/>.

This image is derived from the GNS3 appliance, for details see
<https://github.com/GNS3/gns3-registry/tree/master/docker/openvswitch>

The container creates bridges br0 to br3. By default all eth
interfaces without network configuration are connected to br0.

The custom script `/etc/openvswitch/init.sh` can be used for
additional initializations, e.g. setting an IP address to br0.
