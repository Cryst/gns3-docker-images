FROM alpine

#
# install iouyap and tini
#
RUN set -e -x -o pipefail \
    && printf '\0\0\0\0' > /etc/hostid \
    && apk upgrade \
    && apk add iouyap tini \
#
# install IOUtools (and python3)
#
    && apk add python3 \
    && rm -rf /var/cache/apk/* \
    && wget -q -P /usr/local/bin https://git.bernhard-ehlers.de/ehlers/IOUtools/raw/branch/master/iou_import \
    && wget -q -P /usr/local/bin https://git.bernhard-ehlers.de/ehlers/IOUtools/raw/branch/master/iou_export \
    && chmod +x /usr/local/bin/iou_import /usr/local/bin/iou_export

ADD libc-i386.tar.gz /
ADD init.sh /etc/

CMD [ "sh", "/etc/init.sh" ]
