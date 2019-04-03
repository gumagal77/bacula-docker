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
#cd /usr/share/bacula-director/

MYSQL_OPTS="--host=${DB_HOST} --user=bacula --password=${BACULA_DB_PASSWORD} --database=bacula"

/usr/local/bin/update_mysql_tables.sh ${MYSQL_OPTS} || die "Failed to update database"
/usr/local/bin/grant_mysql_privileges.sh ${MYSQL_OPTS} || die "Failed to grant privileges"

log "Database update completed without errors"
