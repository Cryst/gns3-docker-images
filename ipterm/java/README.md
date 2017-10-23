# web_java - Firefox Web Browser, Java and Java Web Start

This image contains the Firefox web browser, Java and
Java web start. Please note, that Firefox has disabled
the Java plugin, so this is not included in this image.
To ease the use with Cisco ASDM a laucher has been added.

This appliance contains the following networking tools:

- Firefox web browser
- Java (OpenJDK 8 Java runtime environment)
- Java web start / JNLP (IcedTea NetX)
- Launcher for Cisco ASDM
- net-tools (basic network administration tools)
- iproute2 (advanced network administration tools)
- ping and traceroute
- curl (data transfer utility)
- host (DNS lookup utility)
- iperf3
- mtr (full screen traceroute)
- socat (utility for reading/writing from/to network connections)
- ssh client
- tcpdump
- telnet
- mtools (multicast tools msend & mreceive),
  see https://github.com/troglobit/mtools

## Build and publish the Image

Before webterm and ipterm-base has to be build.

```
docker build -t web_java .
docker push web_java
```
