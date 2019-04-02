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

BACULA_FD_CONFIG="/etc/bacula/bacula-fd.conf"
BACULA_FD_PID_FILE="/var/run/bacula-fd.9102.pid"
BACULA_FD_COMMAND="/usr/sbin/bacula-fd -c ${BACULA_FD_CONFIG}"

/usr/local/bin/create_dhparam.sh || die "Failed to generate dhparam"

rm -fv ${BACULA_FD_PID_FILE} || die "Failed to remove stale PID file"

# Test configuration file first
${BACULA_FD_COMMAND} -t || die "Configuration test failed"

# Launch bacula-fd
${BACULA_FD_COMMAND} || die "Failed to start bacula-fd"

log "Bacula FD started."

# Check if config or certificates were changed and restart if necessary
while inotifywait -q -r --exclude '\.git/' -e modify,create,delete,move,move_self /etc/bacula /etc/letsencrypt; do
  log "Configuration changes detected. Will restart bacula-sd in 60 seconds..."
  sleep 60
  pkill -F ${BACULA_FD_PID_FILE} || log_error "Failed to kill bacula-fd"
  sleep 10
  ${BACULA_FD_COMMAND} || die "Failed to restart bacula-fd"
  sleep 20
done
