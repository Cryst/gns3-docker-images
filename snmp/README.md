# snmp - SNMP tools

This image includes the NET-SNMP command line tools
(<http://net-snmp.sourceforge.net>) and the
Free SNMP MIB Browser from ManageEngine
<https://www.manageengine.com/products/mibbrowser-free-tool/>.

Furthermore the basic networking tools from ipterm are included.

Like ipterm, the /root directory is persistent.

## Build the Image

Before ipterm-base has to be build.

Then you need to download the Linux 64-bit version of the
Free SNMP MIB Browser from the URL above and store it in this
directory. Afterwards unpack it with `sh unpack_MibBrowser`.

Now you can build it with:

```
docker build -t snmp .
```
