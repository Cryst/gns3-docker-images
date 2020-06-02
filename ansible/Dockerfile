# docker image with Ansible and basic networking tools
FROM ehlers/ipterm-base

RUN set -e -x \
#
# install ansible
#
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
       ansible sshpass \
#
# install dependencies for junos network modules
#
    && apt-get -y --no-install-recommends install \
       python3-ncclient python3-junos-eznc \
    && apt-get -y --no-install-recommends install \
       python3-pip python3-wheel \
    && pip3 install --no-cache-dir jxmlease \
    && apt-get autoremove -y --purge python3-pip python3-wheel \
    && rm -rf /var/lib/apt/lists/* \
#
# some ansible modules expect the python interpreter in /usr/bin/python
#
    && ln -s python3 /usr/bin/python \
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
cd; exec bash -i -l\n' \
        > /etc/init.sh && chmod +x /etc/init.sh

VOLUME [ "/root", "/etc/ansible" ]
CMD [ "/etc/init.sh" ]
