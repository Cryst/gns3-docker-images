# Ostinato appliance

Ostinato is an open-source, cross-platform network packet
crafter/traffic generator and analyzer with a friendly GUI.
Craft and send packets of several streams with different
protocols at different rates.

It's possible to control the ostinato server/drone from
an external ostinato GUI. Select any interface as a
controlling interface, connect it via a cloud connection
to the outside and setup IP in the node configuration.

For more information see http://ostinato.org/ and
http://www.b-ehlers.de/projects/ostinato4gns3/index.html

This appliance is optimized to run within GNS3.
To run it locally use xhost to allow access to X and then
start the image privileged with access to the host interfaces.

```text
xhost +local:
docker run -it --net=host --privileged -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix ehlers/ostinato
```
