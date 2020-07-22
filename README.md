
[![npm (scoped)](https://img.shields.io/npm/v/@xpack-dev-tools/cmake.svg)](https://www.npmjs.com/package/@xpack-dev-tools/cmake/)
[![npm](https://img.shields.io/npm/dt/@xpack-dev-tools/cmake.svg)](https://www.npmjs.com/package/@xpack-dev-tools/cmake/)

# The xPack CMake

This open source project is hosted on GitHub as
[`xpack-dev-tools/cmake-xpack`](https://github.com/xpack-dev-tools/cmake-xpack)
and provides the platform specific binaries for the
[xPack CMake](https://xpack.github.io/cmake/).

This distribution follows the official [CMake](http://cmake.org) build system.

The binaries can be installed automatically as **binary xPacks** or manually as
**portable archives**.

In addition to the package meta data, this project also includes
the build scripts.

## User info

This section is intended as a shortcut for those who plan
to use the CMake binaries. For full details please read the
[xPack CMake](https://xpack.github.io/cmake/) pages.

### Easy install

The easiest way to install CMake is using the **binary xPack**, available as
[`@xpack-dev-tools/cmake`](https://www.npmjs.com/package/@xpack-dev-tools/cmake)
from the [`npmjs.com`](https://www.npmjs.com) registry.

#### Prerequisites

The only requirement is a recent
`xpm`, which is a portable
[Node.js](https://nodejs.org) command line application. To install it,
follow the instructions from the
[xpm](https://xpack.github.io/xpm/install/) page.

#### Install

With the `xpm` tool available, installing
the latest version of the package is quite easy:

```console
$ xpm install --global @xpack-dev-tools/cmake@latest
```

This command will always install the latest available version,
into the central xPacks repository, which is a platform dependent folder
(check the output of the `xpm` command for the actual folder used on
your platform).

This location is configurable using the environment variable
`XPACKS_REPO_FOLDER`; for more details please check the
[xpm folders](https://xpack.github.io/xpm/folders/) page.

xPacks aware tools, like the **Eclipse Embedded CDT** automatically
identify binaries installed with
`xpm` and provide a convenient method to manage paths.

#### Uninstall

To remove the installed xPack, the command is similar:

```console
$ xpm uninstall --global @xpack-dev-tools/cmake
```

(Note: not yet implemented. As a temporary workaround, simply remove the
`xPacks/@xpack-dev-tools/cmake` folder, or one of the the versioned
subfolders.)

### Manual install

For all platforms, the **xPack CMake** binaries are released as portable
archives that can be installed in any location.

The archives can be downloaded from the
[GitHub Releases](https://github.com/xpack-dev-tools/cmake-xpack/releases/)
page.

For more details please read the
[Install](https://xpack.github.io/cmake/install/) page.

## Maintainer info

- [How to build](https://github.com/xpack-dev-tools/cmake-xpack/blob/xpack/README-BUILD.md)
- [How to publish](https://github.com/xpack-dev-tools/cmake-xpack/blob/xpack/README-PUBLISH.md)
- [How to publish](https://github.com/xpack-dev-tools/cmake-xpack/blob/xpack/README-DEVELOP.md)

## Support

The quick answer is to use the
[xPack forums](https://www.tapatalk.com/groups/xpack/);
please select the correct forum.

For more details please read the
[Support](https://xpack.github.io/cmake/support/) page.

## License

The original content is released under the
[MIT License](https://opensource.org/licenses/MIT), with all rights
reserved to [Liviu Ionescu](https://github.com/ilg-ul).

The binary distributions include several open-source components; the
corresponding licenses are available in the installed
`distro-info/licenses` folder.

## Download analytics

- GitHub [`xpack-dev-tools/cmake-xpack`](https://github.com/xpack-dev-tools/cmake-xpack/) repo
  - latest xPack release
[![Github All Releases](https://img.shields.io/github/downloads/xpack-dev-tools/cmake-xpack/latest/total.svg)](https://github.com/xpack-dev-tools/cmake-xpack/releases/)
  - all xPack releases [![Github All Releases](https://img.shields.io/github/downloads/xpack-dev-tools/cmake-xpack/total.svg)](https://github.com/xpack-dev-tools/cmake-xpack/releases/)
  - [individual file counters](https://www.somsubhra.com/github-release-stats/?username=xpack-dev-tools&repository=cmake-xpack) (grouped per release)
- npmjs.com [`@xpack-dev-tools/cmake`](https://www.npmjs.com/package/@xpack-dev-tools/cmake/) xPack
  - latest release, per month
[![npm (scoped)](https://img.shields.io/npm/v/@xpack-dev-tools/cmake.svg)](https://www.npmjs.com/package/@xpack-dev-tools/cmake/)
[![npm](https://img.shields.io/npm/dm/@xpack-dev-tools/cmake.svg)](https://www.npmjs.com/package/@xpack-dev-tools/cmake/)
  - all releases [![npm](https://img.shields.io/npm/dt/@xpack-dev-tools/cmake.svg)](https://www.npmjs.com/package/@xpack-dev-tools/cmake/)

Credit to [Shields IO](https://shields.io) for the badges and to
[Somsubhra/github-release-stats](https://github.com/Somsubhra/github-release-stats)
for the individual file counters.
