# docker image with NAPALM, Netmiko and basic networking tools

FROM ehlers/ipterm-base

RUN set -e -x \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
       python3 python3-pip python3-cryptography \
    && apt-get -y --no-install-recommends install \
       python3-dev gcc \
    && pip3 install --no-cache-dir napalm \
    && rm -rf /root/.cache \
    && apt-get -y --purge autoremove \
       python3-dev gcc \
    && rm -rf /var/lib/apt/lists/*

VOLUME [ "/root" ]
CMD [ "sh", "-c", "cd; exec bash -i" ]
