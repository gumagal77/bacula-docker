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

PSQL_OPTS="-h ${DB_HOST} -U postgres"

./update_mysql_tables ${PSQL_OPTS} || die "Failed to update database"
./grant_mysql_privileges ${PSQL_OPTS} || die "Failed to grant privileges"

log "Database update completed without errors"
