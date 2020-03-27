#!/bin/sh

#  demo-wrapper.sh
#
#
#  Created by Nataniel López on 24/03/2020.
#

# Import the vm-wrapper library
source "$(dirname $0)/.vm-wrapper/vm-wrapper.sh"

# Specify which commands are supported by this wrapper (required)
supportedCommands=(
	'echo',
)

vmWrapperExec "echo" $@
