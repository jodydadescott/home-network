#!/bin/bash

run=true

main() {

  [[ "$MODE" == "run" ]] || {
    cat /usr/local/share/helper.script
    return 0
  }

  [[ "$HOSTNAME" ]] && { hostname "$HOSTNAME"; }

  [ -d "/config" ] || { err "Directory /config does not exist"; return 2; }
  [ -d "/tools" ] || { err "Directory /tools does not exist"; return 2; }

  install_tools || { err "Failed to install tools"; return 2; }

  set_traps

  local rc
  rc=0
  err "Executing script /tools/bootstrap 0 start"
  /tools/bootstrap 0 start
  rc=$?
  [[ "$rc" -eq 0 ]] || { err "/tools/bootstrap 0 start returned non-zero code $rc"; return "$rc"; }

  err "Executing script /tools/bootstrap 1 restart"
  /tools/bootstrap 1 restart
  [[ "$rc" -eq 0 ]] || { err "/tools/bootstrap 1 start returned non-zero code $rc"; return "$rc"; }

  sleep_forever
  err "Goodbye"
  return 0
}

function install_tools() {
  install -m 755 /usr/local/share/bootstrap /tools/bootstrap || return 2
  install -m 644 /usr/local/share/containershell /tools/containershell || return 2
}

function set_traps() {
  trap sigterm SIGTERM
  trap sigint SIGINT
  trap sighup SIGHUP
}

function sigterm() { err "Caught SIGTERM"; run=false; }
function sigint() { err "Caught SIGINT"; run=false; }
function sighup() { err "Caught SIGHUP"; }

function sleep_forever() {
  err "Sleeping forever"
  while $run; do
    sleep 1
  done
}

function sleep_for() {
  local t=$1
  [ "$t" -eq "$t" ] || { err "$t is must be a positive integer"; return 2; }
  [ "$t" -gt 0 ] || { err "$t is an integer but must be positived"; return 2; }
  err "Sleeping for $t second(s)"
  local c=0
  while $run; do
    ((c=c+1))
    [ "$c" -gt "$t" ] && { err "Sleep done"; return 0; }
    sleep 1
  done
  err "Sleep returning early due to run set to false"
  return 2
}

function err() { echo "$@" 1>&2; }

main "$@"
