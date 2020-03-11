# Docker Open vSwitch

This appliance provides an Open vSwitch, it's based on Alpine Linux.
Open vSwitch is documented at <http://docs.openvswitch.org/en/stable/>.

This image is derived from the GNS3 appliance, for details see
<https://github.com/GNS3/gns3-registry/tree/master/docker/openvswitch>

On the first run the container creates bridges br0 to br3.
All eth interfaces without network configuration are
connected to br0.

In subsequent starts of the VM, the config of the previous
run is restored.

The IP configuration of the bridge interfaces, such as br0,
can be set using the normal /etc/network/interfaces file.
It's recommended to omit/comment any `auto br<if>` lines,
otherwise you will get a (harmless) warning during startup.
The custom script `/etc/openvswitch/init.sh` can be used for
additional initializations.
