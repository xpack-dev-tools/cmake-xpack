---

title:  xPack CMake v3.20.6-1 released
sidebar: cmake

summary: "Version **3.20.6-1** is a new release; it follows the upstream release."

version: 3.20.6-1
npm_subversion: 1

download_url: https://github.com/xpack-dev-tools/cmake-xpack/releases/tag/v3.20.6-1/

date: 2021-10-19 00:45:04 +0300

redirect_from:
  - /blog/2021/10/19/cmake-v3-20-6-1-released/

redirect_to: https://xpack-dev-tools.github.io/cmake-xpack/blog/2021/10/18/cmake-v3-20-6-1-released/

comments: true

categories:
  - releases
  - cmake

tags:
  - releases
  - cmake
  - build

---

The [xPack CMake](https://xpack.github.io/dev-tools/cmake/)
is a standalone cross-platform binary distribution of
[CMake](https://cmake.org).

There are separate binaries for **Windows** (x64 and x86),
**macOS** (x64) and **GNU/Linux** (x64 and x86, arm64 and arm).

{% include note.html content="The main targets for the GNU/Linux Arm
binaries are the **Raspberry Pi** class devices (armv7l and aarch64;
armv6 is not supported)." %}

## Download

The binary files are available from [GitHub Releases]({{ page.download_url }}).

## Prerequisites

- x86/x64 GNU/Linux: any system with **GLIBC 2.15** or higher
  (like Ubuntu 12 or later, Debian 8 or later, RedHat/CentOS 7 later,
  Fedora 20 or later, etc)
- arm64/arm GNU/Linux: any system with **GLIBC 2.23** or higher
  (like Ubuntu 16 or later, Debian 9 or later, RedHat/CentOS 8 or later,
  Fedora 24 or later, etc)
- x86/x64 Windows: Windows 7 with the Universal C Runtime
  ([UCRT](https://support.microsoft.com/en-us/topic/update-for-universal-c-runtime-in-windows-c0514201-7fe6-95a3-b0a5-287930f3560c)),
  Windows 8, Windows 10
- x64 macOS: 10.13 or later

## Install

The full details of installing the **xPack CMake** on various platforms
are presented in the separate [Install]({{ site.baseurl }}/dev-tools/cmake/install/) page.

### Easy install

The easiest way to install CMake is with
[`xpm`]({{ site.baseurl }}/xpm/)
by using the **binary xPack**, available as
[`@xpack-dev-tools/cmake`](https://www.npmjs.com/package/@xpack-dev-tools/cmake)
from the [`npmjs.com`](https://www.npmjs.com) registry.

With the `xpm` tool available, installing
the latest version of the package and adding it as
a dependency for a project is quite easy:

```sh
cd my-project
xpm init # Only at first use.

xpm install @xpack-dev-tools/cmake@latest

ls -l xpacks/.bin
```

To install this specific version, use:

```sh
xpm install @xpack-dev-tools/cmake@{{ page.version }}.{{ page.npm_subversion }}
```

It is also possible to install Meson Build globally, in the user home folder,
but this requires xPack aware tools to automatically identify them and
manage paths.

```sh
xpm install --global @xpack-dev-tools/cmake@latest --verbose
```

### Uninstall

To remove the links from the current project:

```sh
cd my-project

xpm uninstall @xpack-dev-tools/cmake
```

To completely remove the package from the central xPacks store:

```sh
xpm uninstall --global @xpack-dev-tools/cmake
```

## Compliance

The **xPack CMake** is based on the official
[CMake](https://cmake.org), with minimal changes.

The current version is based on:

- CMake release
[3.20.6](https://github.com/Kitware/CMake/releases/tag/v3.20.6/)
from Sep 20, 2021.

## Changes

Compared to the upstream version, the Windows version also supports
spawning scripts via `cmd.exe /c`. These scripts are used by **npm**/**xpm**
to redirect invocations to the central packages repository.

## Bug fixes

- none

## Enhancements

- none

## Known problems

- none

## Shared libraries

On all platforms the packages are standalone, and expect only the standard
runtime to be present on the host.

All dependencies that are build as shared libraries are copied locally
in the `libexec` folder (or in the same folder as the executable for Windows).

### `DT_RPATH` and `LD_LIBRARY_PATH`

On GNU/Linux the binaries are adjusted to use a relative path:

```console
$ readelf -d library.so | grep runpath
 0x000000000000001d (RPATH)            Library rpath: [$ORIGIN]
```

In the GNU ld.so search strategy, the `DT_RPATH` has
the highest priority, higher than `LD_LIBRARY_PATH`, so if this later one
is set in the environment, it should not interfere with the xPack binaries.

Please note that previous versions, up to mid-2020, used `DT_RUNPATH`, which
has a priority lower than `LD_LIBRARY_PATH`, and does not tolerate setting
it in the environment.

### `@executable_path`

Similarly, on macOS, the binaries are adjusted with `otool` to use a
relative path.

## Documentation

The current version specific CMake documentation is available in each packet:

- `doc/cmake-X.Y/html/index.html`

and online from:

- [https://cmake.org/documentation/](https://cmake.org/documentation/)

## Build

The binaries for all supported platforms
(Windows, macOS and GNU/Linux) were built using the
[xPack Build Box (XBB)](https://xpack.github.io/xbb/), a set
of build environments based on slightly older distributions, that should be
compatible with most recent systems.

The scripts used to build this distribution are in:

- `distro-info/scripts`

For the prerequisites and more details on the build procedure, please see the
[README-MAINTAINER](https://github.com/xpack-dev-tools/cmake-xpack/blob/xpack/README-MAINTAINER.md) page.

## CI tests

Before publishing, a set of simple tests were performed on an exhaustive
set of platforms. The results are available from:

- [GitHub Actions](https://github.com/xpack-dev-tools/cmake-xpack/actions/)
- [Travis CI](https://app.travis-ci.com/github/xpack-dev-tools/cmake-xpack/builds/)

## Tests

TBD

## Checksums

The SHA-256 hashes for the files are:

```txt
21b1f7e0728bede25794e84b4ebc9a83af789fc883e67e192cb2e86e8a31eb7c
xpack-cmake-3.20.6-1-darwin-x64.tar.gz

011205173011c6a4923e3539012a279d4842397545c72a8ee3d3b0dd66cfeb9c
xpack-cmake-3.20.6-1-linux-arm.tar.gz

c7ff4ef4ba94c07e2cff3a23a211194665d4fd28fd1f62e4851c4f20adc722c6
xpack-cmake-3.20.6-1-linux-arm64.tar.gz

6db27c5c3c23845bb6a70a9caa21e587405c89df4a230745c91c9cf53b211c8f
xpack-cmake-3.20.6-1-linux-ia32.tar.gz

609b9881a76be69feed185906294e7382c7b3df3c68436fff14fa219df5e7031
xpack-cmake-3.20.6-1-linux-x64.tar.gz

971460daca3e980bc8437d1dbe3d8ddffa5c758df7e97c6bdb53b22bdfd36b63
xpack-cmake-3.20.6-1-win32-ia32.zip

40321974552ee7901d712e3a02c52b430829d58763f7cd7592885cc1f18bf0e0
xpack-cmake-3.20.6-1-win32-x64.zip

```

## Deprecation notices

### 32-bit support

Support for 32-bit x86 GNU/Linux and x86 Windows will most probably
be dropped in 2022. Support for 32-bit Arm GNU/Linux will be preserved
for a while, due to the large user base of 32-bit Raspberry Pi systems.

### GNU/Linux minimum requirements

Support for RedHat 7 will most probably be dropped in 2022, and the
minimum requirement will be raised to GLIBC 2.27, available starting
with Ubuntu 18 and RedHat 8.

## Download analytics

- GitHub [xpack-dev-tools/cmake-xpack](https://github.com/xpack-dev-tools/cmake-xpack/)
  - this release [![Github All Releases](https://img.shields.io/github/downloads/xpack-dev-tools/cmake-xpack/v/total.svg)](https://github.com/xpack-dev-tools/cmake-xpack/releases/v/)
  - all xPack releases [![Github All Releases](https://img.shields.io/github/downloads/xpack-dev-tools/cmake-xpack/total.svg)](https://github.com/xpack-dev-tools/cmake-xpack/releases/)
  - [individual file counters](https://somsubhra.github.io/github-release-stats/?username=xpack-dev-tools&repository=cmake-xpack) (grouped per release)
- npmjs.com [@xpack-dev-tools/cmake](https://www.npmjs.com/package/@xpack-dev-tools/cmake)
  - latest releases [![npm](https://img.shields.io/npm/dw/@xpack-dev-tools/cmake.svg)](https://www.npmjs.com/package/@xpack-dev-tools/cmake/)
  - all @xpack-dev-tools releases [![npm](https://img.shields.io/npm/dt/@xpack-dev-tools/cmake.svg)](https://www.npmjs.com/package/@xpack-dev-tools/cmake/)

Credit to [Shields IO](https://shields.io) for the badges and to
[Somsubhra/github-release-stats](https://github.com/Somsubhra/github-release-stats)
for the individual file counters.
