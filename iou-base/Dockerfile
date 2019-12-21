FROM alpine

#
# install iouyap and tini
#
RUN set -e -x -o pipefail \
    && printf '\0\0\0\0' > /etc/hostid \
    && apk --no-cache add iouyap tini \
#
# install IOUtools (and python3)
#
    && apk --no-cache add python3 \
    && wget -q -P /usr/local/bin https://git.bernhard-ehlers.de/ehlers/IOUtools/raw/branch/master/iou_import \
    && wget -q -P /usr/local/bin https://git.bernhard-ehlers.de/ehlers/IOUtools/raw/branch/master/iou_export \
    && chmod +x /usr/local/bin/iou_import /usr/local/bin/iou_export

ADD libc-i386.tar.gz /
ADD init.sh /etc/

CMD [ "sh", "/etc/init.sh" ]
