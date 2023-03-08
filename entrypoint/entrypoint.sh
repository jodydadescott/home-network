#!/bin/bash
# shellcheck disable=SC1091,SC1090,SC2015

WAIT_FOR_FILE="/etc/cloudflared.conf"
WAIT_RETRY_INT_DEFAULT=30
WAIT_RETRY_MAX_DEFAULT=600

run=true

function main() {
  [[ "$HOSTNAME" ]] && { hostname "$HOSTNAME" ||:; }

  wait_retry_int=$WAIT_RETRY_INT_DEFAULT

  [[ "$WAIT_RETRY_INT" ]] && {
    wait_retry_int=$WAIT_RETRY_INT
    err "wait_retry_int=$wait_retry_int (user)"
  } || {
    err "wait_retry_int=$wait_retry_int (user)"
  }

  [[ "$CONF_RETRY_MAX" ]] && {
    err "CONF_RETRY_MAX=$CONF_RETRY_MAX (user)"
  } || {
    CONF_RETRY_MAX=$CONF_RETRY_MAX_DEFAULT
    err "CONF_RETRY_MAX=$CONF_RETRY_MAX (default)"
  }

  [[ "$CONF_FILE" ]] || { err "CONF_FILE is not set"; return 2; }

  wait_for_conf || return $?

  [ -f "/config/${SERVICE_NAME}/init_service" ] || { err "File /config/${SERVICE_NAME}/init_service not found"; return 2; }

  source "/config/${SERVICE_NAME}/init_service" || return 2

  pre_init_service || { err "pre_init_service failed"; return 2; }
  init_service || { err "init_service failed"; return 2; }
  return 0
}

function wait_for_conf() {

  local c=0

  is_ready && {
    err "ready on first try"
    return 0
  }

  err "config is not ready; waiting on config"

  trap sigterm SIGTERM
  trap sigint SIGINT
  trap sighup SIGHUP

  while $run; do
    is_ready && {
      err "config is now ready"
      return 0
    }
    ((c=c+1))
    err "config is still not ready"
    sleep_for 10
  done
  err "shutdown called before config was ready"
  return 2
}

function is_ready() {
  [ -f $CONF_FILE ] || return 2
  return 0
}

function sleep_for() {
  local t=$1
  [ "$t" -eq "$t" ] || { err "$t is must be a positive integer"; return 2; }
  [ "$t" -gt 0 ] || { err "$t is an integer but must be positived"; return 2; }
  err "Sleeping for $t second(s)"
  local c=0
  while $run; do
    ((c=c+1))
    [ "$c" -gt "$t" ] && return 0
    sleep 1
  done
}

function sigterm() { err "Caught SIGTERM"; run=false; }
function sigint() { err "Caught SIGINT"; run=false; }
function sighup() { err "Caught SIGHUP"; }

function err() { echo "$@" 1>&2; }

main "$@"
