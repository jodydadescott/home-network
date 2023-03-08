#!/bin/bash

# shellcheck disable=SC1091
source /libcommon || { echo "Failed to source /libcommon" 1>&2; exit 2; }

run=true
sig=false

function main() {

  [[ "$HOSTNAME" ]] && { hostname "$HOSTNAME"; }

  set_env
  [ -d "$CONFIG" ] || { err "Directory $CONFIG does not exist"; return 2; }
  initd_dir="${CONFIG}/init.d"
  [ -d "$initd_dir" ] || { err "Directory $initd_dir does not exist"; return 2; }

  trap sigterm SIGTERM
  trap sigint SIGINT
  trap sighup SIGHUP

  run_daemon "$initd_dir" &

  err "Running bootstrap up on boot"
  bootstrap up

  while $run; do
    [ "$sig" == true ] && {
      err "Running bootstrap on signal"
      bootstrap start
      sig=false
    }
    sleep 1
  done
  return 0
}

function run_daemon() {
  # shellcheck disable=SC2162,SC2034
  inotifywait -q -m -r -e close_write "$1" | while read DIRECTORY EVENT FILE; do
  file="${DIRECTORY}${FILE}"
  [ -x "$file" ] && {
    err "Executing file $file on close_write"
    "$file" up;
  }
  done
}

function sigterm() { err "Shutting down on SIGTERM"; run=false; }
function sigint() { err "Shutting down on SIGINT"; run=false; }
function sighup() { err "Running event loop on SIGHUP"; sig=true; }

main "$@"
