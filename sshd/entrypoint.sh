#!/bin/bash

function main() {

  [[ "$CONFIG" ]] || CONFIG=/config
  [ -d "$CONFIG" ] || { err "Directory $CONFIG does not exist"; return 2; }

  err "Running pre_init_ssh"
  pre_init_ssh || { err "pre_init_ssh failed"; return 3; }

  err "Running pre_init_keys"
  pre_init_keys || { err "pre_init_keys failed"; return 3; }

  err "Executing sshd"
  # shellcheck disable=SC2086
  exec /usr/sbin/sshd -D -e $SSHD_OPTS
}

function pre_init_keys() {
  [ -d "$CONFIG/authorized_keys" ] || { err "Directory ${CONFIG}/authorized_keys does not exist"; return 2; }
  [ "$(ls -A "$CONFIG/authorized_keys")" ] || { err "Directory $CONFIG/authorized_keys is empty"; return 2; }

  pass=$(gpg --gen-random --armor 1 14)
  echo "admin:$pass" | chpasswd

  mkdir -p /home/admin/.ssh
  cat "$CONFIG/authorized_keys/"* > /home/admin/.ssh/authorized_keys
  chown -Rf admin:admin /home/admin/.ssh/authorized_keys
  chmod 400 /home/admin/.ssh/authorized_keys
}

function pre_init_ssh() {
  [ -d "$CONFIG/ssh" ] || { err "Directory ${CONFIG}/ssh does not exist"; return 2; }
  [ "$(ls -A "$CONFIG/ssh")" ] || { err "Directory $CONFIG/ssh is empty"; return 2; }

  rm -rf /etc/ssh
  cp -r "$CONFIG/ssh" /etc/ssh

  for f in "/etc/ssh/"*; do
    echo "Processing $f"
    if [[ "$f" == *"key"* ]]; then
      if [[ "$f" == *".pub"* ]]
        then
          chmod 644 "$f"
        else
          chmod 400 "$f"
      fi
    fi
  done
}

err() { echo "$@" 1>&2; }

main "$@"
