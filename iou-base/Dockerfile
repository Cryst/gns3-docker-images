FROM alpine

#
# install iouyap, tini and development tools to run PyInstaller
#
RUN set -e -x -o pipefail \
    && printf '\0\0\0\0' > /etc/hostid \
    && apk --no-cache add iouyap tini \
    && apk --no-cache add --virtual build-deps python3-dev zlib-dev gcc musl-dev wget ca-certificates \
    && cd /tmp \
#
# better ldd, show correct path for ld-musl library
#
    && rm /usr/bin/ldd \
    && printf '\
\043!/bin/sh\n\
exec /lib/ld-musl-* --list -- "$@"\n' \
        > /usr/bin/ldd \
    && chmod +x /usr/bin/ldd \
#
# install PyInstaller
# based on https://github.com/six8/pyinstaller-alpine
#
    && tag=$(wget -q -O - https://api.github.com/repos/pyinstaller/pyinstaller/releases/latest | sed -n 's/^ *"tag_name": "\([^"]*\).*/\1/p') \
    && wget -q -O - https://github.com/pyinstaller/pyinstaller/archive/${tag}.tar.gz | tar xz \
    && cd pyinstaller*/bootloader \
    && CFLAGS="-Wno-stringop-overflow" python3 ./waf configure --no-lsb all \
    && cd .. \
    && pip3 install --no-cache-dir . \
    && cd .. \
    && rm -rf pyinstaller* \
#
# freeze iou_import, iou_export
#
    && wget -q https://git.bernhard-ehlers.de/ehlers/IOUtools/raw/branch/master/iou_import \
    && wget -q https://git.bernhard-ehlers.de/ehlers/IOUtools/raw/branch/master/iou_export \
    && pyinstaller iou_import \
    && pyinstaller iou_export \
    && mkdir -p /usr/local/lib/IOUtools \
    && cp -a dist/iou_import/* dist/iou_export/* /usr/local/lib/IOUtools/ \
    && rm /usr/local/lib/IOUtools/ld-musl-* \
    && ln -s /usr/local/lib/IOUtools/iou_* /usr/local/bin/ \
    && rm -rf iou_import iou_export *.spec build dist \
#
# cleanup
#
    && pip3 uninstall --quiet --yes PyInstaller altgraph future macholib pefile \
    && rm -rf /usr/lib/python3*/site-packages/PyInstaller \
    && rm -rf /root/.cache \
    && apk del build-deps

ADD libc-i386.tar.gz /
ADD init.sh /etc/

CMD [ "sh", "/etc/init.sh" ]
