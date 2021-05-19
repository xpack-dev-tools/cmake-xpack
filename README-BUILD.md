# How to build the xPack CMake binaries

## Introduction

This project includes the scripts and additional files required to
build and publish the
[xPack CMake](https://github.com/xpack-dev-tools/cmake-xpack) binaries.

The build scripts use the
[xPack Build Box (XBB)](https://github.com/xpack/xpack-build-box),
a set of elaborate build environments based on recent GCC versions
(Docker containers
for GNU/Linux and Windows or a custom folder for MacOS).

There are two types of builds:

- **local/native builds**, which use the tools available on the
  host machine; generally the binaries do not run on a different system
  distribution/version; intended mostly for development purposes;
- **distribution builds**, which create the archives distributed as
  binaries; expected to run on most modern systems.

This page documents the distribution builds.

For native builds, see the `build-native.sh` script. (to be added)

## Repositories

- `https://github.com/xpack-dev-tools/cmake-xpack.git` - the URL of the
  [xPack CMake fork](https://github.com/xpack-dev-tools/cmake-xpack)
- `https://github.com/xpack-dev-tools/build-helper` - the URL of the
  xPack build helper, used as the `scripts/helper` submodule
- `https://gitlab.kitware.com/cmake/cmake` - the URL of the original CMake repo
- `https://github.com/Kitware/CMake` - the URL of the GitHub fork

The original releases are distributed via

- `https://github.com/Kitware/CMake/releases`

### Branches

- `xpack` - the updated content, used during builds
- `xpack-develop` - the updated content, used during development
- `master` - empty

## Prerequisites

The prerequisites are common to all binary builds. Please follow the
instructions in the separate
[Prerequisites for building binaries](https://xpack.github.io/xbb/prerequisites/)
page and return when ready.

Note: Building the Arm binaries requires an Arm machine.

## Download the build scripts

The build scripts are available in the `scripts` folder of the
[`xpack-dev-tools/cmake-xpack`](https://github.com/xpack-dev-tools/cmake-xpack)
Git repo.

To download them, use the following two commands:

```sh
rm -rf ~/Downloads/cmake-xpack.git

git clone \
  --recurse-submodules \
  https://github.com/xpack-dev-tools/cmake-xpack.git \
  ~/Downloads/cmake-xpack.git
```

> Note: the repository uses submodules; for a successful build it is
> mandatory to recurse the submodules.

To use the `xpack-develop` branch of the build scripts, issue:

```sh
rm -rf ~/Downloads/cmake-xpack.git

git clone \
  --recurse-submodules \
  --branch xpack-develop \
  https://github.com/xpack-dev-tools/cmake-xpack.git \
  ~/Downloads/cmake-xpack.git
```

## The `Work` folder

The scripts create a temporary build `Work/cmake-${version}` folder in
the user home. Although not recommended, if for any reasons you need to
change the location of the `Work` folder,
you can redefine `WORK_FOLDER_PATH` variable before invoking the script.

## Spaces in folder names

Due to the limitations of `make`, builds started in folders with
spaces in names are known to fail.

If on your system the work folder is in such a location, redefine it in a
folder without spaces and set the `WORK_FOLDER_PATH` variable before invoking
the script.

## Customizations

There are many other settings that can be redefined via
environment variables. If necessary,
place them in a file and pass it via `--env-file`. This file is
either passed to Docker or sourced to shell. The Docker syntax
**is not** identical to shell, so some files may
not be accepted by bash.

## Versioning

The version string is an extension to semver, the format looks like `3.19.8-1`.
It includes the three digits with the original CMake version and a fourth
digit with the xPack release number.

When publishing on the **npmjs.com** server, a fifth digit is appended.

## Changes

Compared to the original CMake distribution, there should be no
functional changes.

The actual changes for each version are documented in the
release web pages.

## How to build local/native binaries

### README-DEVELOP.md

The details on how to prepare the development environment for CMake are in the
[`README-DEVELOP.md`](https://github.com/xpack-dev-tools/cmake-xpack/blob/xpack/README-DEVELOP.md) file.

## How to build distributions

## Build

Although it is perfectly possible to build all binaries in a single step
on a macOS system, due to Docker specifics, it is faster to build the
GNU/Linux and Windows binaries on a GNU/Linux system and the macOS binary
separately.

### Build the Intel GNU/Linux and Windows binaries

The current platform for GNU/Linux and Windows production builds is an
Manjaro 19, running on an Intel NUC8i7BEH mini PC with 32 GB of RAM
and 512 GB of fast M.2 SSD.

```sh
caffeinate ssh xbbi
```

Before starting a build, check if Docker is started:

```sh
docker info
```

Before running a build for the first time, it is recommended to preload the
docker images.

```sh
bash ~/Downloads/cmake-xpack.git/scripts/build.sh preload-images
```

The result should look similar to:

```console
$ docker images
REPOSITORY          TAG                              IMAGE ID            CREATED             SIZE
ilegeul/ubuntu      i386-12.04-xbb-v3.2              fadc6405b606        2 days ago          4.55GB
ilegeul/ubuntu      amd64-12.04-xbb-v3.2             3aba264620ea        2 days ago          4.98GB
```

Since the build takes a while, use `screen` to isolate the build session
from unexpected events, like a broken
network connection or a computer entering sleep.

```sh
screen -S cmake

sudo rm -rf ~/Work/cmake-*
bash ~/Downloads/cmake-xpack.git/scripts/build.sh --all
```

or, for development builds:

```sh
bash ~/Downloads/cmake-xpack.git/scripts/build.sh --develop --without-html --linux64 --linux32 --win64 --win32
```

To detach from the session, use `Ctrl-a` `Ctrl-d`; to reattach use
`screen -r cmake`; to kill the session use `Ctrl-a` `Ctrl-k` and confirm.

About 20 minutes later, the output of the build script is a set of 4
archives and their SHA signatures, created in the `deploy` folder:

```console
$ ls -l ~/Work/cmake-*/deploy
total 102876
-rw-rw-r-- 1 ilg ilg 26299790 Sep 29 12:03 xpack-cmake-3.19.8-1-linux-ia32.tar.gz
-rw-rw-r-- 1 ilg ilg      104 Sep 29 12:03 xpack-cmake-3.19.8-1-linux-ia32.tar.gz.sha
-rw-rw-r-- 1 ilg ilg 24994587 Sep 29 11:53 xpack-cmake-3.19.8-1-linux-x64.tar.gz
-rw-rw-r-- 1 ilg ilg      104 Sep 29 11:53 xpack-cmake-3.19.8-1-linux-x64.tar.gz.sha
-rw-rw-r-- 1 ilg ilg 25556341 Sep 29 12:08 xpack-cmake-3.19.8-1-win32-x32.zip
-rw-rw-r-- 1 ilg ilg      101 Sep 29 12:08 xpack-cmake-3.19.8-1-win32-x32.zip.sha
-rw-rw-r-- 1 ilg ilg 28469621 Sep 29 11:58 xpack-cmake-3.19.8-1-win32-x64.zip
-rw-rw-r-- 1 ilg ilg      101 Sep 29 11:58 xpack-cmake-3.19.8-1-win32-x64.zip.sha
```

To copy the files from the build machine to the current development
machine, either use NFS to mount the entire folder, or open the `deploy`
folder in a terminal and use `scp`:

```sh
(cd ~/Work/cmake-*/deploy; scp * ilg@wks:Downloads/xpack-binaries/cmake)
```

#### Build the Arm GNU/Linux binaries

The supported Arm architectures are:

- `armhf` for 32-bit devices
- `arm64` for 64-bit devices

The current platform for Arm GNU/Linux production builds is a
Debian 9, running on an ROCK Pi 4 SBC with 4 GB of RAM
and 256 GB of fast M.2 SSD. The machine name is `xbba`.

```sh
caffeinate ssh xbba
```

Before starting a build, check if Docker is started:

```sh
docker info
```

Before running a build for the first time, it is recommended to preload the
docker images.

```sh
bash ~/Downloads/cmake-xpack.git/scripts/build.sh preload-images
```

The result should look similar to:

```console
$ docker images
REPOSITORY          TAG                                IMAGE ID            CREATED             SIZE
ilegeul/ubuntu      arm32v7-16.04-xbb-v3.2             b501ae18580a        27 hours ago        3.23GB
ilegeul/ubuntu      arm64v8-16.04-xbb-v3.2             db95609ffb69        37 hours ago        3.45GB
hello-world         latest                             a29f45ccde2a        5 months ago        9.14kB
```

Since the build takes a while, use `screen` to isolate the build session
from unexpected events, like a broken
network connection or a computer entering sleep.

```sh
screen -S cmake

sudo rm -rf ~/Work/cmake-*
bash ~/Downloads/cmake-xpack.git/scripts/build.sh --all
```

To detach from the session, use `Ctrl-a` `Ctrl-d`; to reattach use
`screen -r cmake`; to kill the session use `Ctrl-a` `Ctrl-k` and confirm.

About 50 minutes later, the output of the build script is a set of 2
archives and their SHA signatures, created in the `deploy` folder:

```console
$ ls -l ~/Work/cmake-*/deploy
total 45744
-rw-rw-r-- 1 ilg ilg 23714604 Sep 29 09:14 xpack-cmake-3.19.8-1-linux-arm64.tar.gz
-rw-rw-r-- 1 ilg ilg      106 Sep 29 09:14 xpack-cmake-3.19.8-1-linux-arm64.tar.gz.sha
-rw-rw-r-- 1 ilg ilg 23114964 Sep 29 09:38 xpack-cmake-3.19.8-1-linux-arm.tar.gz
-rw-rw-r-- 1 ilg ilg      104 Sep 29 09:38 xpack-cmake-3.19.8-1-linux-arm.tar.gz.sha
```

To copy the files from the build machine to the current development
machine, either use NFS to mount the entire folder, or open the `deploy`
folder in a terminal and use `scp`:

```sh
(cd ~/Work/cmake-*/deploy; scp * ilg@wks:Downloads/xpack-binaries/cmake)
```

#### Build the macOS binaries

The current platform for macOS production builds is a macOS 10.10.5
running on a MacBook Pro with 32 GB of RAM and a fast SSD.

```sh
caffeinate ssh xbbm
```

To build the latest macOS version:

```sh
screen -S cmake

rm -rf ~/Work/cmake-*

caffeinate bash ~/Downloads/cmake-xpack.git/scripts/build.sh --osx
```

To detach from the session, use `Ctrl-a` `Ctrl-d`; to reattach use
`screen -r cmake`; to kill the session use `Ctrl-a` `Ctrl-\` or
`Ctrl-a` `Ctrl-k` and confirm.

Several minutes later, the output of the build script is a compressed
archive and its SHA signature, created in the `deploy` folder:

```console
$ ls -l ~/Work/cmake-*/deploy
total 38472
-rw-r--r--  1 ilg  staff  19689560 Sep 29 11:56 xpack-cmake-3.19.8-1-darwin-x64.tar.gz
-rw-r--r--  1 ilg  staff       105 Sep 29 11:56 xpack-cmake-3.19.8-1-darwin-x64.tar.gz.sha
```

To copy the files from the build machine to the current development
machine, either use NFS to mount the entire folder, or open the `deploy`
folder in a terminal and use `scp`:

```sh
(cd ~/Work/cmake-*/deploy; scp * ilg@wks:Downloads/xpack-binaries/cmake)
```

### Subsequent runs

#### Separate platform specific builds

Instead of `--all`, you can use any combination of:

```console
--win32 --win64 --linux32 --linux64
--arm --arm64
```

#### `clean`

To remove most build temporary files, use:

```sh
bash ~/Downloads/cmake-xpack.git/scripts/build.sh --all clean
```

To also remove the library build temporary files, use:

```sh
bash ~/Downloads/cmake-xpack.git/scripts/build.sh --all cleanlibs
```

To remove all temporary files, use:

```sh
bash ~/Downloads/cmake-xpack.git/scripts/build.sh --all cleanall
```

Instead of `--all`, any combination of `--win32 --win64 --linux32 --linux64`
will remove the more specific folders.

For production builds it is recommended to completely remove the build folder.

#### `--develop`

For performance reasons, the actual build folders are internal to each
Docker run, and are not persistent. This gives the best speed, but has
the disadvantage that interrupted builds cannot be resumed.

For development builds, it is possible to define the build folders in
the host file system, and resume an interrupted build.

#### `--debug`

For development builds, it is also possible to create everything with
`-g -O0` and be able to run debug sessions.

#### Interrupted builds

The Docker scripts run with root privileges. This is generally not a
problem, since at the end of the script the output files are reassigned
to the actual user.

However, for an interrupted build, this step is skipped, and files in
the install folder will remain owned by root. Thus, before removing
the build folder, it might be necessary to run a recursive `chown`.

## Testing

A simple test is performed by the script at the end, by launching the
executable to check if all shared/dynamic libraries are correctly used.

For a true test you need to unpack the archive in a temporary location
(like `~/Downloads`) and then run the
program from there. For example on macOS the output should
look like:

```console
$ /Users/ilg/Work/cmake-3.19.8-1/darwin-x64/install/cmake/bin/cmake --version
cmake version 3.19.8
```

## Installed folders

After install, the package should create a structure like this (macOS files;
only the first two depth levels are shown):

```console
$ tree -L 2 /Users/ilg/Library/xPacks/\@xpack-dev-tools/cmake/3.19.8-1.1/.content/
/Users/ilg/Library/xPacks/\@xpack-dev-tools/cmake/3.19.8-1.1/.content/
├── README.md
├── bin
│   ├── ccmake
│   ├── cmake
│   ├── cpack
│   ├── ctest
│   ├── libc++.1.dylib
│   ├── libc++abi.dylib
│   ├── libgcc_s.1.dylib
│   └── libncurses.6.dylib
├── distro-info
│   ├── licenses
│   ├── patches
│   └── scripts
└── share
    ├── aclocal
    └── cmake-3.18

8 directories, 9 files
```

No other files are installed in any system folders or other locations.

## Uninstall

The binaries are distributed as portable archives; thus they do not need
to run a setup and do not require an uninstall; simply removing the
folder is enough.

## Files cache

The XBB build scripts use a local cache such that files are downloaded only
during the first run, later runs being able to use the cached files.

However, occasionally some servers may not be available, and the builds
may fail.

The workaround is to manually download the files from an alternate
location (like
<https://github.com/xpack-dev-tools/files-cache/tree/master/libs>),
place them in the XBB cache (`Work/cache`) and restart the build.

## More build details

The build process is split into several scripts. The build starts on
the host, with `build.sh`, which runs `container-build.sh` several
times, once for each target, in one of the two docker containers.
Both scripts include several other helper scripts. The entire process
is quite complex, and an attempt to explain its functionality in a few
words would not be realistic. Thus, the authoritative source of details
remains the source code.
