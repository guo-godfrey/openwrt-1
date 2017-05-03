#
# Copyright (C) 2010 OpenWrt.org
#

. /lib/ls.sh

platform_check_image() {
	local board=$(ls_board_name)

	case "$board" in
	ls1012a-rdb)
		nand_do_platform_check $board $1
		return $?;
		;;
	esac

	echo "Sysupgrade is not yet supported on $board."
	return 1
}
