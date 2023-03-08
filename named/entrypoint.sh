#!/bin/bash
# shellcheck disable=SC2015

run=true

CONFIG_FILE_DEFAULT="/etc/named/named.conf"

function main() {

  [[ "$DELAY" ]] && {
    err "Delay IS set; sleeping for $DELAY"
    # We sleep for DELAY but if we receive a shutdown signal during the sleep
    # we return 0
    sleep_for "$DELAY" || return 0
    err "Sleep over"

  } || { err "Delay is NOT set"; }

  [ "$CONFIG_FILE" ] && {
    err "CONFIG_FILE=$CONFIG_FILE (env)"
  } || {
    CONFIG_FILE="$CONFIG_FILE_DEFAULT"
    err "CONFIG_FILE=$CONFIG_FILE (default)"
  }

  [ -f "$CONFIG_FILE" ] || {
    err "File $CONFIG_FILE not found"; return 2;
    sleep_for 20
    return 2
  }

  [ "$PRE_HOOK" ] && {
    err "Executing PRE_HOOK $PRE_HOOK"
    $PRE_HOOK; rc=$?
    [[ "$rc" -eq 0 ]] || {
      err "PRE_HOOK returned $rc"
      return "$rc"
    }
  }

  exec /usr/sbin/named -fg -c "$CONFIG_FILE"
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
  return 2
}

function sigterm() { err "Caught SIGTERM"; run=false; }
function sigint() { err "Caught SIGINT"; run=false; }
function sighup() { err "Caught SIGHUP"; }

function err() { echo "$@" 1>&2; }

main "$@"
