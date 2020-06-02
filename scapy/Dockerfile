# docker image with scapy and basic networking tools

FROM ehlers/ipterm-base

RUN set -e -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
       python3-scapy python3-cryptography libwireshark-data \
    && mkdir -p /usr/local/share/wireshark \
    && cp -p /usr/share/wireshark/manuf /usr/local/share/wireshark/ \
    && apt-get -y purge libwireshark-data \
    && ln -s /usr/bin/scapy3 /usr/local/bin/scapy \
    && rm -rf /var/lib/apt/lists/*

VOLUME [ "/root" ]
CMD [ "sh", "-c", "cd; exec bash -i -l" ]
