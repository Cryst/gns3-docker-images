# nicer alpine image

FROM alpine

RUN set -ex \
#
# install busybox-extras, dumb-init and nodnsd
#
    && apk add --update-cache busybox-extras dumb-init \
    && mkdir -p /usr/local/sbin \
    && cd /usr/local/sbin \
    && url=`wget -q -O - https://git.bernhard-ehlers.de/api/v1/repos/ehlers/nodnsd/releases | sed -n 's/^.*"browser_download_url": *"\([^"]*\).*/\1/p'` \
    && if [ -z "$url" ]; then echo "nodnsd package not found" >&2; exit 1; fi \
    && wget -q -O nodnsd $url \
    && chmod 755 nodnsd \
    && cd - \
    && rm -rf /var/cache/apk/* \
#
# add gns3 user
#
    && echo -e 'gns3\ngns3' | adduser gns3 \
#
# startup script
#
    && echo -e '\
\x23!/bin/sh\n\
[ $$ -eq 1 ] && exec dumb-init -r 15:1 -- "$0" "$@"\n\
\n\
nodnsd\n\
\n\
if [ $# -gt 0 ]; then\n\
	exec "$@"\n\
else\n\
	cd; exec ash -i\n\
fi' \
        > /etc/init.sh && chmod +x /etc/init.sh

ENTRYPOINT [ "/etc/init.sh" ]
VOLUME [ "/root", "/home/gns3" ]
