ARG  ceos_version
FROM ceosimage:${ceos_version}

COPY console-getty.service getty.target /usr/lib/systemd/system/
RUN  rm /etc/systemd/system/getty.target.wants/getty@tty1.service

ENV  CEOS=1 \
     container=docker \
     EOS_PLATFORM=ceoslab \
     SKIP_ZEROTOUCH_BARRIER_IN_SYSDBINIT=1 \
     ETBA=1 \
     INTFTYPE=eth
VOLUME [ "/mnt/flash" ]
CMD  ["/sbin/init"]
