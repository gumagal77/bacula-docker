FROM ubuntu:18.10
MAINTAINER Gustavo Magalhães <gumagalcomp77@gmail.com>

RUN apt-get update && apt-get install -y --no-install-recommends \
    bacula-fd \
    inotify-tools \
    openssl \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

VOLUME /etc/bacula
VOLUME /var/lib/bacula
VOLUME /etc/dhparam

COPY create_dhparam.sh entrypoint.sh /usr/local/bin/

ENTRYPOINT /usr/local/bin/entrypoint.sh

EXPOSE 9102
