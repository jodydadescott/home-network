CONFIG_DEFAULT="/config"

function set_env() {
  # shellcheck disable=SC2015
  [[ "$CONFIG" ]] && {
    err "CONFIG is set to $CONFIG (env)"
  } || {
    CONFIG="$CONFIG_DEFAULT"
    err "CONFIG set to $CONFIG (default)"
  }

  export CONFIG=$CONFIG
}

function bootstrap() {
  fail=0
  set_env

  [ -d "$CONFIG" ] || { err "Directory $CONFIG does not exist"; return 2; }
  initd_dir="${CONFIG}/init.d"
  [ -d "$initd_dir" ] || { err "Directory $initd_dir does not exist"; return 2; }

  for script in "${initd_dir}"/* ; do
    # shellcheck disable=SC2015
    [ -x "$script" ] && {
      err "Running script $script"
      $script "$1" || ((fail=fail+1))
    } || {
      err "File $script exist but is not executable"
    }
  done

  [ "$fail" -eq 0 ] && { err "There were no failures"; return 0; }

  err "There were $fail failures"
  fail=0
  return 3
}

function err() { echo "$@" 1>&2; }
