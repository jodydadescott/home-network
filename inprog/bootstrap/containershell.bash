TOOLS_DIR_DEFAULT="/tools"
CONFIG_DIR_DEFAULT="/config"

function run() {
  [[ "$TOOLS_DIR" ]] || TOOLS_DIR="$TOOLS_DIR_DEFAULT"
  [[ "$CONFIG_DIR" ]] || CONFIG_DIR="$CONFIG_DIR_DEFAULT"

  script="$(basename "$0")"

   case "$1" in
     start) start ;;
     stop) stop ;;
     restart) restart ;;
     *) err "Usage: $script start | stop | restart"; return 2; ;;
   esac
  return 0
}

function pre_start() { true; }
function post_start() { true; }

function pre_stop() { true; }
function post_stop() { true; }

function enable_docker() {
  ARGS+=" --volume /var/run/docker:/var/run/docker:ro "
  ARGS+=" --volume /var/run/docker.sock:/var/run/docker.sock:rw "
  ARGS+=" --volume /var/run/docker.pid:/var/run/docker.pid:ro "
}

function args_check() {
  local rc
  rc=0
  [[ "$NAME" ]] || { err "Missing NAME"; rc=2; }
  [[ "$IMAGE" ]] || { err "Missing IMAGE"; rc=2; }
  return "$rc"
}

function start() {
  args_check || return 2
  [[ "$(is_running)" == "yes" ]] && { err "already running"; return 0; }
  _start || { err "start failed"; return 3; }
}

function _start() {
  pre_start || return $?
  # shellcheck disable=SC2086
  args="docker run "
  args+=" $ARGS "
  args+=" --detach "
  args+=" --rm "
  [[ "$DNS" ]] || { args+=" --dns=$DNS "; }
  args+=" --volume $CONFIG_DIR:/config:rw "
  args+=" --volume $TOOLS_DIR:/tools:ro "
  args+=" --name $NAME -e HOSTNAME=$NAME "
  args+=" --volume /etc/localtime:/etc/localtime:ro "
  args+=" $IMAGE "
  # err "Running cmd->$args"
  $args || { err "Command failed: cmd->$args"; return $?; }
  post_start || return $?
}

function set_name { NAME="$1"; }
function set_image { IMAGE="$1"; }

function set_dns() { DNS="$1"; }
function set_network_host() { ARGS+=" --network host "; }
function set_privileged() { ARGS+=" --privileged "; }
function set_hostpid() { ARGS+=" --pid=host "; }

function add_rw_device() {
  host="$1"
  container="$2"
  [[ "$container" ]] || { container="$host"; }
  ARGS+=" --device $host:$container:rw ";
}

function add_rw_vol() {
  host="$1"
  container="$2"
  [[ "$container" ]] || { container="$host"; }
  ARGS+=" --volume $host:$container:rw ";
}

function add_ro_device() {
  host="$1"
  container="$2"
  [[ "$container" ]] || { container="$host"; }
  ARGS+=" --device $host:$container:ro ";
}

function add_ro_vol() {
  host="$1"
  container="$2"
  [[ "$container" ]] || { container="$host"; }
  ARGS+=" --volume $host:$container:ro ";
}

function stop() {
  [[ "$NAME" ]] || { err "Missing NAME"; return 2; }
  [[ "$(is_running)" == "no" ]] && { err "not running"; return 0; }
  _stop || { err "stop failed"; return 3; }
}

function _stop() {
  pre_stop || return $?
  # shellcheck disable=SC2086
  docker stop $NAME || return $?
  post_stop || return $?
}

function restart() {
  args_check || return 2
  [[ "$(is_running)" == "yes" ]] && { _stop || return 3; }
  _start
}

function is_running() {
  status="$(docker inspect --format='{{.State.Status}}' "$NAME" 2>&1)"

  [[ "$status" == "running" ]] && {
    echo "yes"
    return 0
  }
  echo "no"
  return 0
}

function get_pid() {
  [[ "$(is_running)" == "yes" ]] || { echo 0; return 0; }
  docker inspect --format='{{ .State.Pid }}' "$NAME"
  return 0
}

function err() { echo "$@" 1>&2; }
