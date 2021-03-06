# docker image with snmp and basic networking tools

# Unpacking ManageEngine_MibBrowser_FreeTool_64bit.bin
FROM ehlers/ipterm-base

COPY ManageEngine_MibBrowser_FreeTool_64bit.bin /tmp/

RUN set -e -x \
    && chmod +x /tmp/ManageEngine_MibBrowser_FreeTool_64bit.bin \
    && /tmp/ManageEngine_MibBrowser_FreeTool_64bit.bin -silent


# Main image
FROM ehlers/ipterm-base

COPY --from=0 /root/ManageEngine/ManageEngine_Free_Tools/MibBrowser_Free_Tool /opt/MibBrowser
COPY RFC1271-MIB /var/lib/snmp/mibs/ietf/

RUN set -e -x \
#
# install snmp cli tools
#
    && export DEBIAN_FRONTEND=noninteractive \
    && sed -i -e '/^deb / s/$/ non-free/' /etc/apt/sources.list \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
        snmp snmp-mibs-downloader libxtst6 \
        dillo ca-certificates  lxterminal jwm menu mousepad wmctrl \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i -e 's/^mibs/#mibs/' /etc/snmp/snmp.conf \
#
# some fixups
#
    && ln -s /usr/bin/dillo /usr/local/bin/firefox \
    && mv /opt/MibBrowser/MibBrowserlogo.jpg /opt/MibBrowser/MibBrowserlogo.JPG \
#
# customize jwm menu
#
    && printf '\
?package(local.mibbrowser):\\\n\
 needs="x11"\\\n\
 section="Applications"\\\n\
 title="MIB Browser"\\\n\
 command="MibBrowser"\n' \
        > /etc/menu/qtmib \
    && printf '\
?package(mousepad):\\\n\
 needs="x11"\\\n\
 section="Applications/TextEditor"\\\n\
 title="Mousepad"\\\n\
 command="mousepad"\n' \
        > /etc/menu/mousepad \
    && echo "postrun=\"sed -i '/^    </ d' debian-menu\"" >> /etc/menu-methods/jwm \
    && sed -i 's/\(Desktops width\)="[0-9]*"/\1="2"/' /etc/jwm/system.jwmrc \
    && sed -i 's/xterm/x-terminal-emulator/g' /etc/jwm/system.jwmrc \
    && update-menus \
#
# set lxterminal defaults
#
    && mkdir -p /root/.config/lxterminal \
    && printf '\
[general]\n\
scrollback=1000\n\
fgcolor=#ffffff\n' \
        > /root/.config/lxterminal/lxterminal.conf \
#
# MibBrowser start script
#
    && printf '\
\043!/bin/sh\n\
\n\
MB_HOME=/opt/MibBrowser\n\
JAVA_HOME=$MB_HOME/jre\n\
export JAVA_HOME\n\
\n\
cd\n\
mkdir -p MibBrowser\n\
cd MibBrowser\n\
[ -e Templates ] || ln -s "$MB_HOME/Templates" .\n\
[ -e conf ] || cp -a "$MB_HOME/conf" .\n\
[ -e help ] || ln -s "$MB_HOME/help" .\n\
[ -e mibs ] || ln -s "$MB_HOME/mibs" .\n\
[ -e std_mibs ] || ln -s /var/lib/snmp/mibs std_mibs\n\
\n\
CLASSPATH=$MB_HOME/classes:$MB_HOME/conf:$MB_HOME/MibBrowser:$MB_HOME/jars/ApiUtils.jar:$MB_HOME/jars/AdventNetSnmp.jar:$MB_HOME/jars/AdventNetLogging.jar:$MB_HOME/jars/AdventNetCCLXMLParser.jar:$MB_HOME/jars/AdventNetUtils.jar:$MB_HOME/jars/AdventNetCCLUtils.jar:$MB_HOME/jars/AdventNetSnmpUtilitiesSplash.jar:$MB_HOME/jars/MibBrowser.jar:$MB_HOME:$MB_HOME/jars/JimiProClasses.zip:$MB_HOME/jars/AdventNetNPrevalent.jar:$MB_HOME/jars/AdventNetUI.jar:$MB_HOME/jars/Mail.jar:$MB_HOME/jars/activation.jar:$MB_HOME/jars/AdventNetScript.jar:$MB_HOME/jars/jython.jar:$MB_HOME/jars/log4j-1.2.16.jar:$MB_HOME/jars/smslib-3.5.3.jar\n\
\n\
export CLASSPATH\n\
\n\
"$JAVA_HOME/bin/java" -mx200M MibBrowserApplication -h localhost -p 161 -v v1 -c public -m "$MB_HOME/mibs/RFC1213-MIB $MB_HOME/mibs/IF-MIB" -t 5 -r 0\n' \
        > /usr/local/bin/MibBrowser && chmod +x /usr/local/bin/MibBrowser \
#
# startup script
#
    && printf '\
\043!/bin/sh\n\
[ $$ -eq 1 ] && exec dumb-init -- "$0" "$@"\n\
\n\
\043 workaround: sometimes the first start of an X application fails\n\
lxterminal -e true 2> /dev/null\n\
\n\
cd\n\
export SHELL=/bin/bash\n\
\n\
\043 start MibBrowser\n\
MibBrowser &\n\
\n\
\043 start a windows manager if none is active\n\
wmctrl -m > /dev/null 2>&1 && wait $! || jwm\n' \
        > /etc/init.sh && chmod +x /etc/init.sh

VOLUME [ "/root" ]
CMD [ "/etc/init.sh" ]
