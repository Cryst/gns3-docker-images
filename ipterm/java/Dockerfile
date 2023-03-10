# Web browser plus Java

FROM ch4c2h6/webterm

RUN set -e -x \
#
# install Java v8 and Java Web Start
#
    && export DEBIAN_FRONTEND=noninteractive \
    && printf '\
deb http://deb.debian.org/debian stretch main\n\
deb http://security.debian.org/debian-security stretch/updates main\n' \
        > /etc/apt/sources.list.d/stretch.list \
    && apt-get update \
    && mkdir -p /usr/share/man/man1 \
    && apt-get -y --no-install-recommends install \
        icedtea-netx/stretch openjdk-8-jre/stretch java-common/stretch \
        fonts-dejavu-extra yad \
    && apt-mark hold icedtea-netx openjdk-8-jre java-common \
    && apt-get -y --no-install-recommends install filezilla \
    && rm /etc/apt/sources.list.d/stretch.list \
    && rm -rf /var/lib/apt/lists/* \
#
# customize jwm menu
#
    && printf '\
?package(filezilla):\\\n\
 needs="x11"\\\n\
 section="Applications"\\\n\
 title="Filezilla"\\\n\
 command="filezilla"\n' \
        > /etc/menu/filezilla \
    && printf '\
?package(putty):\\\n\
 needs="x11"\\\n\
 section="Applications"\\\n\
 title="PuTTY"\\\n\
 command="putty"\n' \
        > /etc/menu/putty \
    && printf '\
?package(icedtea-netx):\\\n\
 needs="x11"\\\n\
 section="Applications"\\\n\
 title="ASDM Launcher"\\\n\
 command="start-asdm"\n' \
        > /etc/menu/asdm \
    && update-menus \
#
# ASDM Launcher
#
    && printf '\
\043!/bin/sh\n\
\n\
asa_ip=$(yad --entry --title="ASDM Launcher" \\\n\
             --text="\\n  Connects to ASAv by ASDM    \\n" \\\n\
             --entry-text="IP")\n\
[ $? -ne 0 ] && exit 1\n\
[ -z "$asa_ip" ] || [ "$asa_ip" = "IP" ] && exit 1\n\
\n\
javaws "https://$asa_ip/admin/public/asdm.jnlp" < /dev/null\n' \
        > /usr/local/bin/start-asdm \
    && chmod +x /usr/local/bin/start-asdm \
#
# enable MD5
#

    && sed -i 's/jdk.jar.disabledAlgorithms=MD2, MD5, RSA keySize/jdk.jar.disabledAlgorithms=MD2, RSA keySize/' /etc/java-8-openjdk/security/java.security \

#
# enable Default Editor in Filezilla
#

    && sed -i 's/<Setting name="Default editor">0</<Setting name="Default editor">1</' /root/.config/filezilla/filezilla.xml \


#
# startup script
#
    && sed -i '/firefox/d' /etc/init.sh

VOLUME [ "/etc/java-8-openjdk" ]
