ARG ALPINE_VERSION=3.16.2

# ╭――――――――――――――――---------------------------------------------------------――╮
# │                                                                           │
# │ STAGE 1: avahi-container                                                 │
# │                                                                           │
# ╰―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――╯
FROM gautada/alpine:$ALPINE_VERSION

# ╭――――――――――――――――――――╮
# │ METADATA           │
# ╰――――――――――――――――――――╯
LABEL version="2022-11-27"
LABEL source="https://github.com/gautada/avahi-container.git"
LABEL maintainer="Adam Gautier <adam@gautier.org>"
LABEL description="Avahi/Bonjour service container."

# ╭――――――――――――――――――――╮
# │ ENTRYPOINT         │
# ╰――――――――――――――――――――╯
RUN rm -v /etc/container/entrypoint
COPY entrypoint /etc/container/entrypoint

# ╭――――――――――――――――――――╮
# │ PRIVILEGE          │
# ╰――――――――――――――――――――╯
COPY wheel /etc/container/wheel

# ╭――――――――――――――――――――╮
# │ PACKAGES           │
# ╰――――――――――――――――――――╯
# avahi-compat-libdns_sd avahi-dev dbus
RUN /sbin/apk add --no-cache avahi avahi-compat-libdns_sd avahi-tools dbus mdns-scan 

COPY hap.service /etc/avahi/services/hap.service
# COPY avahi-daemon.conf /etc/avahi/avahi-daemon.conf
# RUN echo "192.168.4.203 bridge.gautier.local" >> /etc/avahi/hosts

# ╭――――――――――――――――――――╮
# │ USER               │
# ╰――――――――――――――――――――╯
ARG USER=avahi
RUN /usr/sbin/usermod -s /bin/ash $USER
RUN /usr/sbin/usermod -aG wheel $USER

# USER avahi
