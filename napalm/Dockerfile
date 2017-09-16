# docker image with NAPALM, Netmiko and basic networking tools

FROM ehlers/ipterm-base

RUN set -ex \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install \
       python3 python3-pip python3-setuptools python3-cryptography \
    && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
       python3-dev gcc \
    && pip3 install --no-cache-dir napalm \
    && rm -rf /root/.cache \
    && apt-get -y --purge autoremove \
       python3-dev gcc \
    && rm -rf /var/lib/apt/lists/*

VOLUME [ "/root" ]
CMD [ "sh", "-c", "cd; exec bash -i" ]
