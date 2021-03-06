#!/bin/sh

#  vm-wrapper.sh
#
#
#  Created by Nataniel López on 24/03/2020.
#

vmWrapperPath() {

	if [[ -z $VM_WRAPPER_GUEST_PATH ]]; then
		echo $PWD
		exit
	fi

	if [[ -n $VM_WRAPPER_HOST_PATH ]]; then
		echo $PWD | sed -e "s%$VM_WRAPPER_HOST_PATH%$VM_WRAPPER_GUEST_PATH%g"
	else
		echo "$VM_WRAPPER_GUEST_PATH/${PWD##*/}"
	fi
}

isSupportedCommand() {

	if [[ -z $supportedCommands ]]; then
		echo "Error: Missing supported commands, please add them in your wrapper."
		exit 1
	fi

	if [[ ${supportedCommands[@]} =~ $1 ]]; then
   	true
	else
		false
	fi
}

vmWrapperExec() {

	vmWrapperGuestPath=$(vmWrapperPath)

	# Exit when the vmWrapperPath vm ssh env is not set
	if [[ -z $VM_WRAPPER_SSH ]]; then
		echo 'Error: VM_WRAPPER_SSH env var not set'
		exit 1
	fi

	# Exit when the received vmWrapperPath command is not supported
	if ! isSupportedCommand $1; then
		echo Error: "Unsupported command: \"$1\"".
		exit 1
	fi

	ssh -o LogLevel=QUIET -t $VM_WRAPPER_SSH "if [ -d \"$vmWrapperGuestPath\" ]; then cd \"$vmWrapperGuestPath\"; else cd \"$VM_WRAPPER_GUEST_PATH\"; fi;" $1 ${@:2}
}
