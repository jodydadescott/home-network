#!/bin/bash
# shellcheck disable=SC1091,SC1090

run=true

function main() {

  SERVICE_NAME=$(</.service_name)
  [[ "$SERVICE_NAME" ]] || return 2

  [[ "$HOSTNAME" ]] && { hostname "$HOSTNAME" ||:; }

  wait_for_conf || return $?

  [ -f "/config/${SERVICE_NAME}/init_service" ] || { err "File /config/${SERVICE_NAME}/init_service not found"; return 2; }

  source "/config/${SERVICE_NAME}/init_service" || return 2

  pre_init_service || { err "pre_init_service failed"; return 2; }
  init_service || { err "init_service failed"; return 2; }
  return 0
}

function wait_for_conf() {

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
    err "config is still not ready"
    sleep_for 10
  done
  err "shutdown called before config was ready"
  return 2
}

function is_ready() {
  [ -d "/config" ] || { err "Directory $CONFIG_DIR does not exist"; return 2; }
  [ -d "/config/${SERVICE_NAME}" ] || { err "Directory /config/${SERVICE_NAME} does not exist"; return 2; }
  [ -f "/config/${SERVICE_NAME}/init_service" ] || { err "File /config/${SERVICE_NAME}/init_service does not exist"; return 2; }
  err "Config is ready"
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