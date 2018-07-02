FROM alpine

#
# install iouyap, tini and (frozen) ioutools
#
RUN set -ex \
    && echo -ne '\x00\x00\x00\x00' > /etc/hostid \
    && apk add --update-cache iouyap tini \
    && apk add --virtual build-deps python3-dev gcc musl-dev wget ca-certificates \
    && pip3 install --quiet --no-cache-dir cx_Freeze==5.0.2 \
# install and freeze IOUtools
    && cd /tmp \
    && wget -q https://git.bernhard-ehlers.de/ehlers/IOUtools/raw/branch/master/iou_import \
    && wget -q https://git.bernhard-ehlers.de/ehlers/IOUtools/raw/branch/master/iou_export \
    && echo -e '\
from cx_Freeze import setup, Executable\n\
setup (\n\
    options = { "build_exe": { "build_exe": "/usr/local/bin", "silent": True, "zip_exclude_packages": None, "zip_include_packages": "*" } },\n\
    executables = [ Executable("iou_import"), Executable("iou_export") ]\n\
)' \
        > setup.py \
    && ln -s `which ldd` ldd \
    && python3 setup.py build \
    && rm /usr/local/bin/ldd \
    && rm iou_export iou_import setup.py ldd \
    && cd - \
# cleanup
    && pip3 uninstall --quiet --yes cx_Freeze \
    && rm -rf /root/.cache \
    && apk del build-deps \
    && rm -rf /var/cache/apk/*

ADD libc-i386.tar.gz /
ADD init.sh /etc/

CMD [ "sh", "/etc/init.sh" ]
