#! /bin/bash

die() {
    echo >&2 "[`date +'%Y-%m-%d %T'`] $@"
    exit 1
}

log() {
  if [[ "$@" ]]; then echo "[`date +'%Y-%m-%d %T'`] $@";
  else echo; fi
}

#cd /usr/libexec/bacula/
cd /usr/share/bacula-director/

MYSQL_OPTS="--host=${DB_HOST} --user=bacula --password=${BACULA_DB_PASSWORD} --database=bacula"

#createuser ${PSQL_OPTS} -d -R -e bacula || die "Failed to create user"
#/usr/share/bacula-director/create_mysql_database ${MYSQL_OPTS} || die "Failed to create bacula database"
/usr/local/bin/make_mysql_tables.sh ${MYSQL_OPTS} || die "Failed to make bacula tables"
/usr/local/bin/grant_mysql_privileges.sh ${MYSQL_OPTS} || die "Failed to grant bacula priviledges"

#mysql ${MYSQL_OPTS} --command="alter user bacula with password '${BACULA_DB_PASSWORD}';" bacula || die "Failed to set database bacula user password"

log "Initialization completed without errors"
