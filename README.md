# VM Wrapper
A magic tool to use command line programs from a VM like it was installed locally in your host system (using SSH).

## Installation
Copy the files and folders from `Release` folder into the `/usr/local/bin` directory of you host system and set the ENV vars into your bash profile.
```sh
cp -r Release/. /usr/local/bin
```

## ENV Vars
- `VM_WRAPPER_SSH` **(required)**: The ssh connection in **user@domain** format. Example: `johndoe@localhost`

- `VM_WRAPPER_GUEST_PATH` **(optional)**:
	-	Normally the VMs has a limited access to host FS, this ENV sets the base path of the commands execution inside your VM. Example: if you set this ENV to `/my/shared/folder` and you call a command from `/path/to/somewhere/my-dir` the wrapper will `cd` into the path `/my/shared/folder/my-dir` inside the VM then run the command.
	- By default uses the real CWD of your execution.

- `VM_WRAPPER_HOST_PATH` **(optional)**:
	-	The host path that you want to replace by the guest path inside the VM.
	- Combined with `VM_WRAPPER_GUEST_PATH` can map host directories into the VM. Example: With host path as `'/Volumes/MyVolume'` and guest path as `'/my/shared/folder'` when you execute a command from a CWD like `'/Volumes/MyVolume/myDir/myFiles'`, inside the VM will be redirected to `'/my/shared/folder/myDir/myFiles'`

### ENV detailed examples

#### When both ENVs are set
```sh
export VM_WRAPPER_HOST_PATH="/Volumes/MySharedVolume"
export VM_WRAPPER_GUEST_PATH="/my/shared/folder"

cd "/Volumes/MySharedVolume/path/to/my/CWD"

docker-compose up

# Internally inside the VM before run docker-compose up will do this:
cd "/my/shared/folder/path/to/my/CWD"
# then
docker-compose up
```

#### When only guest path ENV is set
```sh
export VM_WRAPPER_GUEST_PATH="/my/shared/folder"

cd "/Volumes/MySharedVolume/path/to/my/CWD"

docker-compose up

# Internally inside the VM before run docker-compose up will do this:
cd "/my/shared/folder/CWD"
# then
docker-compose up
```

#### When any of the path ENVs are set or only host path is set
```sh
export VM_WRAPPER_HOST_PATH="/Volumes/MySharedVolume"

cd "/Volumes/MySharedVolume/path/to/my/CWD"

docker-compose up

# Internally inside the VM before run docker-compose up will do this:
cd "/Volumes/MySharedVolume/path/to/my/CWD"
# then
docker-compose up
```

## Create a wrapper
To create a wrapper you can use the `demo-wrapper.sh` file for a quick start.

You need to import the vm-wrapper library, set the supportedCommands and execute it with the params that you want.

### Wrapper file example
```sh
#!/bin/sh

# Import the vm-wrapper library
source "$(dirname $0)/.vm-wrapper/vm-wrapper"

# Specify which commands are supported by this wrapper (required)
supportedCommands=(
	'echo',
)

vmWrapperExec "echo" "$@"
```

### Wrapper execution example
```sh
./demo-wrapper.sh hello world
hello world # Executed inside the VM
```