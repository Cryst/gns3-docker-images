# docker image with Ansible and basic networking tools
FROM ehlers/ipterm-base

RUN set -e -x \
#
# install ansible
#
    && export DEBIAN_FRONTEND=noninteractive \
    && echo "deb [trusted=yes] http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" > /etc/apt/sources.list.d/ansible.list \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
       ansible \
#
# install dependencies for junos network modules
#
    && apt-get -y --no-install-recommends install \
       python-lxml python-netaddr python-scp python-serial \
    && apt-get -y --no-install-recommends install \
       python-pip python-wheel \
    && pip install --no-cache-dir ncclient jxmlease junos-eznc \
    && apt-get autoremove -y --purge python-pip python-wheel \
    && rm -rf /var/lib/apt/lists/* \
#
# startup script
#
    && printf '\
\043!/bin/sh\n\
\n\
\043 symlink /etc/hosts to persistent directory\n\
mount | fgrep -q "on /etc/hosts "\n\
if [ $? -ne 0 ]; then\n\
	[ -s /etc/ansible/etc_hosts ] || cp -p /etc/hosts /etc/ansible/etc_hosts\n\
	ln -sf /etc/ansible/etc_hosts /etc/hosts\n\
fi\n\
\n\
cd; exec bash -i\n' \
        > /etc/init.sh && chmod +x /etc/init.sh

VOLUME [ "/root", "/etc/ansible" ]
CMD [ "/etc/init.sh" ]
