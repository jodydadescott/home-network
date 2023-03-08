#!/bin/bash -e

function main() {
  cd "$(dirname "$0")"
  export CONFIG="${PWD}/config"
  /entrypoint.sh ||:
  return 0
}

function err() { echo "$@" 1>&2; }

main "$@"
