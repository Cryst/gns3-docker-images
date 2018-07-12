# docker image with snmp and basic networking tools

FROM ehlers/ipterm-base
ADD ManageEngine_MibBrowser_FreeTool_64bit.tar.gz /opt/MibBrowser/
RUN set -ex \
#
# install snmp cli tools
#
    && export DEBIAN_FRONTEND=noninteractive \
    && sed -i -e '/^deb / s/$/ non-free/' /etc/apt/sources.list \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
        snmp snmp-mibs-downloader libxtst6 dillo lxterminal jwm menu leafpad \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i -e 's/^mibs/#mibs/' /etc/snmp/snmp.conf \
#
# some fixups
#
    && ln -s /usr/bin/dillo /usr/local/bin/firefox \
    && mv /opt/MibBrowser/MibBrowserlogo.jpg /opt/MibBrowser/MibBrowserlogo.JPG \
    &&  curl -s -S -L -o /var/lib/snmp/mibs/ietf/RFC1271-MIB https://www.simpleweb.org/ietf/mibs/modules/IETF/txt/RFC1271-MIB \
#
# customize jwm menu
#
    && /bin/echo -e '\
?package(local.mibbrowser):\\\n\
 needs="x11"\\\n\
 section="Applications"\\\n\
 title="MIB Browser"\\\n\
 command="MibBrowser"' \
        > /etc/menu/qtmib \
    && echo "postrun="\""sed -i '/^    </ d' debian-menu"\" >> /etc/menu-methods/jwm \
    && sed -i 's/\(Desktops width\)="[0-9]*"/\1="2"/' /etc/jwm/system.jwmrc \
    && sed -i 's/xterm/x-terminal-emulator/g' /etc/jwm/system.jwmrc \
    && update-menus \
#
# set lxterminal defaults
#
    && mkdir -p /root/.config/lxterminal \
    && /bin/echo -e '\
[general]\n\
scrollback=1000\n\
fgcolor=#ffffff' \
        > /root/.config/lxterminal/lxterminal.conf \
#
# MibBrowser start script
#
    && /bin/echo -e '\
\x23!/bin/sh\n\
\n\
MB_HOME=/opt/MibBrowser\n\
JAVA_HOME=$MB_HOME/jre\n\
export JAVA_HOME\n\
\n\
cd\n\
mkdir -p MibBrowser\n\
cd MibBrowser\n\
[ -e Templates ] || ln -s $MB_HOME/Templates .\n\
[ -e conf ] || cp -a $MB_HOME/conf .\n\
[ -e help ] || ln -s $MB_HOME/help .\n\
[ -e mibs ] || ln -s $MB_HOME/mibs .\n\
[ -e std_mibs ] || ln -s /var/lib/snmp/mibs std_mibs\n\
\n\
CLASSPATH=$MB_HOME/classes:$MB_HOME/conf:$MB_HOME/MibBrowser:$MB_HOME/jars/ApiUtils.jar:$MB_HOME/jars/AdventNetSnmp.jar:$MB_HOME/jars/AdventNetLogging.jar:$MB_HOME/jars/AdventNetCCLXMLParser.jar:$MB_HOME/jars/AdventNetUtils.jar:$MB_HOME/jars/AdventNetCCLUtils.jar:$MB_HOME/jars/AdventNetSnmpUtilitiesSplash.jar:$MB_HOME/jars/MibBrowser.jar:$MB_HOME:$MB_HOME/jars/JimiProClasses.zip:$MB_HOME/jars/AdventNetNPrevalent.jar:$MB_HOME/jars/AdventNetUI.jar:$MB_HOME/jars/Mail.jar:$MB_HOME/jars/activation.jar:$MB_HOME/jars/AdventNetScript.jar:$MB_HOME/jars/jython.jar:$MB_HOME/jars/log4j-1.2.16.jar:$MB_HOME/jars/smslib-3.5.3.jar\n\
\n\
export CLASSPATH\n\
\n\
$JAVA_HOME/bin/java -mx200M MibBrowserApplication -h localhost -p 161 -v v1 -c public -m "$MB_HOME/mibs/RFC1213-MIB $MB_HOME/mibs/IF-MIB" -t 5 -r 0' \
        > /usr/local/bin/MibBrowser && chmod +x /usr/local/bin/MibBrowser \
#
# startup script
#
    && /bin/echo -e '\
\x23!/bin/sh\n\
[ $$ -eq 1 ] && exec dumb-init -- "$0" "$@"\n\
\n\
\x23 workaround: sometimes the first start of an X application fails\n\
lxterminal -e true 2> /dev/null\n\
\n\
cd\n\
export SHELL=/bin/bash\n\
MibBrowser &\n\
jwm' \
        > /etc/init.sh && chmod +x /etc/init.sh

VOLUME [ "/root" ]
CMD [ "/etc/init.sh" ]
