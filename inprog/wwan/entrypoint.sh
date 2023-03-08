#!/bin/bash

function main() {
  err "Starting"

  [[ "$HOSTNAME" ]] && { hostname "$HOSTNAME"; }

  err "Running"
  wait_for_stop
  err "Goodbye"
}

function wait_for_stop() {
  run=true
  trap sigterm SIGTERM
  trap sigint SIGINT
  trap sighup SIGHUP
  sleep_forever
}

function sigterm() {
  err "Caught SIGTERM"
  run=false
}

function sigint() {
  err "Caught SIGINT"
  run=false
}

function sighup() {
  err "Caught SIGHUP"
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

function sleep_forever() {
  err "Sleeping forever (or until killed)"
  while $run; do
    sleep 1
  done
}

function err() { echo "$@" 1>&2; }

main "$@"
