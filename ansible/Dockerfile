# docker image with Ansible and basic networking tools
FROM ehlers/ipterm-base

RUN set -e -x \
#
# install ansible
#
    && export DEBIAN_FRONTEND=noninteractive \
    && echo "deb http://deb.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/backports.list \
    && apt-get update \
    && apt-get -y --no-install-recommends install -t stretch-backports \
       ansible sshpass \
#
# install dependencies for junos network modules
#
    && apt-get -y --no-install-recommends install \
       python-ncclient python-junos-eznc \
    && apt-get -y --no-install-recommends install \
       python-pip python-wheel \
    && pip install --no-cache-dir jxmlease \
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
