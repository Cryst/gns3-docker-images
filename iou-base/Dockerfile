FROM alpine

#
# install iouyap, tini and (frozen) ioutools
#
RUN set -e -x -o pipefail \
    && printf '\0\0\0\0' > /etc/hostid \
    && apk --no-cache add iouyap tini \
    && apk --no-cache add --virtual build-deps python3-dev gcc musl-dev wget ca-certificates \
    && pip3 install --quiet --no-cache-dir cx_Freeze==5.0.2 \
# install and freeze IOUtools
    && cd /tmp \
    && wget -q https://git.bernhard-ehlers.de/ehlers/IOUtools/raw/branch/master/iou_import \
    && wget -q https://git.bernhard-ehlers.de/ehlers/IOUtools/raw/branch/master/iou_export \
    && printf '\
from cx_Freeze import setup, Executable\n\
setup (\n\
    options = { "build_exe": { "build_exe": "/usr/local/bin", "silent": True, "zip_exclude_packages": None, "zip_include_packages": "*" } },\n\
    executables = [ Executable("iou_import"), Executable("iou_export") ]\n\
)\n' \
        > setup.py \
    && ln -s "$(which ldd)" ldd \
    && python3 setup.py build \
    && rm /usr/local/bin/ldd \
    && rm iou_export iou_import setup.py ldd \
    && cd - \
# cleanup
    && pip3 uninstall --quiet --yes cx_Freeze \
    && rm -rf /root/.cache \
    && apk del build-deps

ADD libc-i386.tar.gz /
ADD init.sh /etc/

CMD [ "sh", "/etc/init.sh" ]
