#!/bin/sh
################################################################################

# Timeout in seconds. Default 10 Minutes
TIMEOUT=600
FILE=/etc/asterisk/asterisk.conf
CMD="/usr/sbin/asterisk -f -C $FILE"

################################################################################

main() { wait_on_file_or_timeout && { exec $CMD; } || return 1; }

# Return 0 if file exist, 1 if timeout or cancel
wait_on_file_or_timeout() {
	[ -f $FILE ] && { err "File $FILE exist on first check"; return 0; }
	err "Waiting for file $FILE to exist or timeout"
	run=1
	trap run=0 SIGINT SIGTERM
	local counter=$TIMEOUT
	while [ true ]; do
		let counter=counter-1
		printf '\rtimeout: %s (seconds)' "$counter"
		# Calling to get newline before message
		[ -f $FILE ] && { err; err "File $FILE exist now"; return 0; }
		[ $counter -le 0 ] &&
			{ err; err "A timeout has occured waiting for file $FILE"; return 1; }
		[ $run -ne 1 ] && { err; err "Cancelled by signal"; return 1; }
		sleep 1
	done
}

err() { echo "$@" 1>&2; }

main $@
