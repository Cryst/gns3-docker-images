# docker image with scapy and basic networking tools

FROM ehlers/ipterm-base

RUN set -ex \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
       python python-cryptography tcpdump \
       python-pip python-setuptools python-wheel \
    && pip install --quiet --no-cache-dir scapy \
    && rm -rf /root/.cache \
    && apt-get -y --purge autoremove python-pip python-wheel \
    && rm -rf /var/lib/apt/lists/*

VOLUME [ "/root" ]
CMD [ "sh", "-c", "cd; exec bash -i" ]
