#FROM ubuntu:18.10

#RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get install -y bacula-director bacula-director-mysql

FROM ubuntu:18.10
MAINTAINER Gustavo Magalhães <gumagalcomp77@gmail.com>

RUN echo "bacula-director-mysql bacula-director-mysql/dbconfig-install boolean false\n" \
      "nullmailer shared/mailname string foo\n" \
      "nullmailer nullmailer/relayhost string bar" | debconf-set-selections
RUN apt-get update && apt-get install -y --no-install-recommends \
    bacula-director \
    bacula-director-mysql \
    bacula-console \
    inotify-tools \
    ssmtp \
    openssl \
    ca-certificates \
    wakeonlan \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/libexec/bacula/ && \
    mv /etc/bacula/scripts/* /usr/libexec/bacula/ && \
    mv /usr/share/bacula-common/defconfig/scripts/* /usr/libexec/bacula/

VOLUME /etc/bacula
VOLUME /var/lib/bacula
VOLUME /etc/dhparam

COPY create_dhparam.sh first_run.sh mail_wrapper.sh entrypoint.sh update_database.sh make_mysql_tables.sh grant_mysql_privileges.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/*

ENTRYPOINT /usr/local/bin/entrypoint.sh

EXPOSE 9101
