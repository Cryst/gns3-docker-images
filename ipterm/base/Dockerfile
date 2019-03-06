# docker base image for basic networking tools

FROM debian:stretch-slim

RUN set -e -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
        curl ca-certificates \
#
# install mtools (msend & mreceive)
#
    && mtools=$(curl -s https://git.bernhard-ehlers.de/api/v1/repos/ehlers/mtools/releases) \
    && url=$(echo "$mtools" | sed -n 's/^.*"msend[^"]*\.bin"[^}]*"browser_download_url": *"\([^"]*\).*/\1/p') \
    && if [ -z "$url" ]; then echo "msend binary not found" >&2; exit 1; fi \
    && curl -s -S -L -o /usr/local/bin/msend "$url" \
    && chown root:root /usr/local/bin/msend \
    && chmod 755 /usr/local/bin/msend \
    && url=$(echo "$mtools" | sed -n 's/^.*"mreceive[^"]*\.bin"[^}]*"browser_download_url": *"\([^"]*\).*/\1/p') \
    && if [ -z "$url" ]; then echo "mreceive binary not found" >&2; exit 1; fi \
    && curl -s -S -L -o /usr/local/bin/mreceive "$url" \
    && chown root:root /usr/local/bin/mreceive \
    && chmod 755 /usr/local/bin/mreceive \
#
# install remaining tools
#
    && apt-get -y --no-install-recommends install \
        dumb-init iperf3 knot-host mtr-tiny openssh-client socat tcpdump \
        net-tools iproute2 ifupdown isc-dhcp-client inetutils-ping \
        telnet traceroute procps nano vim-tiny \
    && rm -rf /var/lib/apt/lists/* \
