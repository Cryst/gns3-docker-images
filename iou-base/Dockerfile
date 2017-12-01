FROM alpine

#
# install iouyap, (frozen) ioutools and run-stop
#
RUN set -ex \
    && echo -ne '\x00\x00\x00\x00' > /etc/hostid \
    && apk add --update-cache iouyap \
    && apk add --virtual build-deps python3-dev gcc musl-dev wget ca-certificates \
    && pip3 install --quiet --no-cache-dir cx_Freeze==5.0.2 \
# install and freeze IOUtools
    && cd /tmp \
    && wget -q https://raw.githubusercontent.com/ehlers/IOUtools/master/iou_import \
    && wget -q https://raw.githubusercontent.com/ehlers/IOUtools/master/iou_export \
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
# add run-stop
    && mkdir -p /usr/local/sbin \
    && url=`wget -q -O - https://api.github.com/repos/ehlers/run-stop/releases/latest | sed -n 's/^ *"browser_download_url": "\([^"]*_amd64\)".*/\1/p'` \
    && if [ -z "$url" ]; then echo "run-stop not found" >&2; exit 1; fi \
    && wget -q -O /usr/local/sbin/run-stop $url \
    && chmod 755 /usr/local/sbin/run-stop \
# cleanup
    && pip3 uninstall --quiet --yes cx_Freeze \
    && rm -rf /root/.cache \
    && apk del build-deps \
    && rm -rf /var/cache/apk/*

ADD libc-i386.tar.gz /
ADD do-run do-stop /etc/init.d/

RUN chmod 755 /etc/init.d/do-run /etc/init.d/do-stop

CMD [ "run-stop", "/etc/init.d/do-run", "---", "/etc/init.d/do-stop" ]
