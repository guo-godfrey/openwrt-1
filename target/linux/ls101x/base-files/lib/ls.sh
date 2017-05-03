#!/bin/sh
#
# Copyright (C) 2010-2013 OpenWrt.org
#

LS_BOARD_NAME=
LS_MODEL=

ls_board_detect() {
	local machine
	local name

	machine=$(cat /proc/device-tree/model)

	case "$machine" in
	"LS1012A RDB Board")
		name="ls1012a-rdb"
		;;

	*)
		name="generic"
		;;
	esac

	[ -z "$LS_BOARD_NAME" ] && LS_BOARD_NAME="$name"
	[ -z "$LS_MODEL" ] && LS_MODEL="$machine"

	[ -e "/tmp/sysinfo/" ] || mkdir -p "/tmp/sysinfo/"

	echo "$LS_BOARD_NAME" > /tmp/sysinfo/board_name
	echo "$LS_MODEL" > /tmp/sysinfo/model
}

ls_board_name() {
	local name

	[ -f /tmp/sysinfo/board_name ] || ls_board_detect
	[ -f /tmp/sysinfo/board_name ] && name=$(cat /tmp/sysinfo/board_name)
	[ -z "$name" ] && name="unknown"

	echo "$name"
}
