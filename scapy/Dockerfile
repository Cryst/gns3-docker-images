# docker image with scapy and basic networking tools

FROM ehlers/ipterm-base

RUN set -e -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
       python3 python3-cryptography netbase tcpdump \
       python3-pip python3-setuptools python3-wheel \
    && pip3 install --quiet --no-cache-dir scapy \
    && rm -rf /root/.cache \
    && apt-get -y --purge autoremove python3-pip python3-wheel \
    && rm -rf /var/lib/apt/lists/*

VOLUME [ "/root" ]
CMD [ "sh", "-c", "cd; exec bash -i" ]
