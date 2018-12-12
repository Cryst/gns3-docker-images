FROM debian:stretch-slim

RUN set -e -x \
#
# install ftp, tftp and ssh server
#
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && echo 'proftpd-basic shared/proftpd/inetd_or_standalone string standalone' | debconf-set-selections \
    && apt-get -y --no-install-recommends install \
        dumb-init proftpd-basic tftpd-hpa openssh-server \
        net-tools iproute2 ifupdown isc-dhcp-client inetutils-ping \
        telnet traceroute procps nano vim-tiny \
    && rm -rf /var/lib/apt/lists/* \
#
# setup ftp, tftp and openssh
#
    && addgroup --system ftp \
    && usermod -d /ftp -g ftp -s /bin/bash ftp \
    && printf 'ftp\nftp\n' | passwd ftp 2> /dev/null \
    && printf '\
\043 A basic anonymous configuration, no security !!!\n\
\n\
<Anonymous ~ftp>\n\
  User			ftp\n\
  Group			ftp\n\
  \043 We want clients to be able to login with "anonymous" as well as "ftp"\n\
  UserAlias		anonymous ftp\n\
\n\
  \043 Don\047t require valid shell for anonymous user\n\
  RequireValidShell	off\n\
\n\
  \043 Limit the maximum number of anonymous logins\n\
  MaxClients		10\n\
\n\
  \043 We want "welcome.msg" displayed at login, and ".message" displayed\n\
  \043 in each newly chdired directory.\n\
  DisplayLogin		welcome.msg\n\
  DisplayChdir		.message\n\
\n\
</Anonymous>\n' \
        > /etc/proftpd/conf.d/anonymous.conf \
\
    && printf '\
\043 /etc/default/tftpd-hpa\n\
\n\
TFTP_USERNAME="ftp"\n\
TFTP_DIRECTORY="/ftp"\n\
TFTP_ADDRESS=":69"\n\
TFTP_OPTIONS="--secure --permissive --create --umask 022"\n' \
        > /etc/default/tftpd-hpa \
\
    && printf '\
\n\
Ciphers +aes256-cbc\n\
KexAlgorithms +diffie-hellman-group1-sha1\n\
\n\
AllowUsers ftp\n' >> /etc/ssh/sshd_config \
    && rm -f /etc/ssh/ssh_host_* \
#
# startup script
#
    && printf '\
\043!/bin/sh\n\
[ $$ -eq 1 ] && exec dumb-init -- "$0" "$@"\n\
\n\
\043 try to set ftp to same user/group id as GNS3 process\n\
\043 /etc/network/interfaces is managed by GNS3\n\
uid=$(stat -c %%u /etc/network/interfaces 2> /dev/null)\n\
if [ "0$uid" -ne 0 ]; then\n\
	gid=$(stat -c %%g /etc/network/interfaces)\n\
	usermod -o -u "$uid" ftp\n\
	groupmod -o -g "$gid" ftp\n\
fi\n\
\n\
\043 create /ftp directory\n\
mkdir -p /ftp\n\
chown ftp:ftp /ftp\n\
chmod 775 /ftp\n\
\n\
\043 create missing SSH keys\n\
ssh-keygen -A\n\
\n\
\043 start ftp, tftp and ssh services\n\
service proftpd start\n\
service tftpd-hpa start\n\
service ssh start\n\
\n\
cd; exec bash -i\n' \
        > /etc/init.sh && chmod +x /etc/init.sh

VOLUME [ "/etc/ssh", "/ftp" ]
CMD [ "/etc/init.sh" ]
