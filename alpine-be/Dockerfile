# nicer alpine image

FROM alpine

RUN set -e -x -o pipefail \
#
# install busybox-extras, dumb-init and nodnsd
#
    && apk --no-cache add busybox-extras dumb-init \
    && mkdir -p /usr/local/sbin \
    && url=$(wget -q -O - https://git.bernhard-ehlers.de/api/v1/repos/ehlers/nodnsd/releases | sed -n 's/^.*"browser_download_url": *"\([^"]*\).*/\1/p') \
    && if [ -z "$url" ]; then echo "nodnsd package not found" >&2; exit 1; fi \
    && wget -q -O /usr/local/sbin/nodnsd "$url" \
    && chmod 755 /usr/local/sbin/nodnsd \
#
# add gns3 user
#
    && printf 'gns3\ngns3\n' | adduser gns3 \
#
# startup script
#
    && printf '\
\043!/bin/sh\n\
[ $$ -eq 1 ] && exec dumb-init -r 15:1 -- "$0" "$@"\n\
\n\
nodnsd\n\
\n\
if [ $# -gt 0 ]; then\n\
	exec "$@"\n\
else\n\
	cd; exec ash -i\n\
fi\n' \
        > /etc/init.sh && chmod +x /etc/init.sh

ENTRYPOINT [ "/etc/init.sh" ]
VOLUME [ "/root", "/home/gns3" ]
