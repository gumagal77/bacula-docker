#! /bin/sh

die () {
    log_error $@
    exit 1
}

log () {
  echo "[`date +'%Y-%m-%d %T'`] $@";
}

log_error () {
  echo >&2 "[`date +'%Y-%m-%d %T'`] $@"
}

BACULA_SD_CONFIG="/etc/bacula/bacula-sd.conf"
BACULA_SD_PID_FILE="/var/run/bacula-sd.9103.pid"
BACULA_SD_COMMAND="/usr/sbin/bacula-sd -c ${BACULA_SD_CONFIG}"

/usr/local/bin/create_dhparam.sh || die "Failed to generate dhparam"

rm -fv ${BACULA_SD_PID_FILE} || die "Failed to remove stale PID file"

# Test configuration file first
${BACULA_SD_COMMAND} -t || die "Configuration test failed"

# Launch bacula-sd
${BACULA_SD_COMMAND} || die "Failed to start bacula-sd"

log "Bacula SD started."

# Check if config or certificates were changed and restart if necessary
while inotifywait -q -r --exclude '\.git/' -e modify,create,delete,move,move_self /etc/bacula /etc/letsencrypt; do
  log "Configuration changes detected. Will restart bacula-sd in 60 seconds..."
  sleep 60
  pkill -F ${BACULA_SD_PID_FILE} || log_error "Failed to kill bacula-sd"
  sleep 10
  ${BACULA_SD_COMMAND} || die "Failed to restart bacula-sd"
  sleep 20
done
