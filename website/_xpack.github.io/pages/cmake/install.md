---

title: How to install the xPack CMake binaries
permalink: /dev-tools/cmake/install/

summary: "The recommended method is via xpm."

version: "3.21.6"
xpack-subversion: "1"
version-major-minor: "3.21"

comments: true
toc: false

date: 2020-09-29 14:05:00 +0300

redirect_to: https://xpack-dev-tools.github.io/cmake-xpack/docs/install/

---

## Overview

The **xPack CMake** can be installed automatically, via `xpm` (the
recommended method), or manually, by downloading and unpacking one of the
portable archives.

{% capture easy_install %}

## Easy install

The easiest way to install CMake is by using the **binary xPack**, available as
[`@xpack-dev-tools/cmake`](https://www.npmjs.com/package/@xpack-dev-tools/cmake)
from the [`npmjs.com`](https://www.npmjs.com) registry.

### Prerequisites

The only requirement is a recent
xpm, which is a portable
[Node.js](https://nodejs.org) command line application. To install it,
follow the instructions from the
[xpm install]({{ site.baseurl }}/xpm/install/) page.

### Install

With xpm available, installing
the latest version of the package is quite easy:

```sh
cd my-project
xpm init # Only at first use.

xpm install @xpack-dev-tools/cmake@latest --verbose
```

This command will always install the latest available version,
in the global xPacks store, which is a platform dependent folder
(check the output of the `xpm` command for the actual folder used on
your platform).

{% capture include_1 %}
The install location can be configured using the
`XPACKS_STORE_FOLDER` environment variable; for more details please check the
[xpm folders]({{ site.baseurl }}/xpm/folders/) page.
{% endcapture %}

{% include tip.html content=include_1 %}

{% include tip.html content="The archive content is unpacked into a folder
named `.content`. On some platforms
this might be hidden for normal browsing, and require
separate options (like `ls -A`) or, in file browsers, to enable
settings like **Show Hidden Files**." %}

### Uninstall

To remove the links from the current project:

```sh
cd my-project

xpm uninstall @xpack-dev-tools/cmake
```

To completely remove the package from the central xPacks store:

```sh
xpm uninstall --global @xpack-dev-tools/cmake --verbose
```

{% endcapture %}

{% capture manual_install %}

## Manual install

For all platforms, the **xPack CMake** binaries are released as portable
archives that can be installed in any location.

The archives can be downloaded from the
GitHub [releases](https://github.com/xpack-dev-tools/cmake-xpack/releases/)
page.

{% endcapture %}

{% capture windows %}

{{ easy_install }}

### Test

To check if the xpm installed CMake starts, use something like:

```doscon
C:\>%USERPROFILE%\AppData\Roaming\xPacks\@xpack-dev-tools\cmake\{{ page.version }}-{{ page.xpack-subversion }}.1\.content\bin\cmake.exe --version
cmake version {{ page.version }}

CMake suite maintained and supported by Kitware (kitware.com/cmake).
```

{{ manual_install }}

### Download

The Windows versions of **xPack CMake**
are packed as ZIP files.
Download the latest version named like:

- `xpack-cmake-{{ page.version }}-{{ page.xpack-subversion }}-win32-x64.zip`

{% include note.html content="In case you wonder where the suffix comes
from, it is exactly the Node.js `process.platform` and `process.arch`.
The `win32` part is confusing, but we have to live with it." %}

### Unpack

To manually install the xPack CMake,
unpack the archive and copy it into the
`%USERPROFILE%\AppData\Roaming\xPacks\cmake`
(for example `C:\Users\ilg\AppData\Roaming\xPacks\cmake`) folder;
according to Microsoft, `AppData\Roaming` is the recommended location for
installing user specific packages.

{% include note.html content="For manual installs, the recommended
install location is slightly different from the xpm install folders,
which use the scope (like `@xpack-dev-tools`) to group different tools,
and `.content` to store the unpacked archive." %}

### Test

To check if the manually installed CMake starts, use something like:

```doscon
C:\>%USERPROFILE%\AppData\Roaming\xPacks\cmake\xpack-cmake-{{ page.version }}-{{ page.xpack-subversion }}\bin\cmake.exe --version
cmake version {{ page.version }}

CMake suite maintained and supported by Kitware (kitware.com/cmake).
```

{% endcapture %}

{% capture macos %}

{{ easy_install }}

### Test

To check if the xpm installed CMake starts, use something like:

```console
$ ~/Library/xPacks/@xpack-dev-tools/cmake/{{ page.version }}-{{ page.xpack-subversion }}.1/.content/bin/cmake --version
cmake version {{ page.version }}

CMake suite maintained and supported by Kitware (kitware.com/cmake).
```

{{ manual_install }}

### Download

The macOS versions of **xPack CMake**
are packed as `.tar.gz` archives.
Download the latest version named like:

- `xpack-cmake-{{ page.version }}-{{ page.xpack-subversion }}-darwin-x64.tar.gz`
- `xpack-cmake-{{ page.version }}-{{ page.xpack-subversion }}-darwin-arm64.tar.gz`

### Unpack

To manually install the xPack CMake,
unpack the archive and move it to
`~/.local/xPacks/cmake/xpack-cmake-{{ page.version }}-{{ page.xpack-subversion }}`:

```sh
mkdir -p ~/.local/xPacks/cmake
cd ~/.local/xPacks/cmake

tar xvf ~/Downloads/xpack-cmake-{{ page.version }}-{{ page.xpack-subversion }}-darwin-x64.tar.gz
chmod -R -w xpack-cmake-{{ page.version }}-{{ page.xpack-subversion }}
```

{% include note.html content="For manual installs, the recommended
install location is different from the xpm install folders." %}

The result is a structure like:

```console
$ tree -L 2 /Users/ilg/.local/xPacks/cmake/xpack-cmake-{{ page.version }}-{{ page.xpack-subversion }}
/Users/ilg/Library/.local/cmake/xpack-cmake-{{ page.version }}-{{ page.xpack-subversion }}/
├── README.md
├── bin
│   ├── ccmake
│   ├── cmake
│   ├── cpack
│   └── ctest
├── distro-info
│   ├── CHANGELOG.md
│   ├── licenses
│   ├── patches
│   └── scripts
├── doc
│   └── cmake-{{ page.version-major-minor }}
├── libexec
│   └── libncurses.6.dylib
└── share
    ├── aclocal
    ├── bash-completion
    ├── cmake-{{ page.version-major-minor }}
    ├── emacs
    └── vim

14 directories, 7 files
```

### Test

To check if the manually installed CMake starts, use something like:

```console
$ ~/.local/xPacks/cmake/xpack-cmake-{{ page.version }}-{{ page.xpack-subversion }}/bin/cmake --version
cmake version {{ page.version }}
```

{% endcapture %}

{% capture linux %}

{{ easy_install }}

### Test

To check if the xpm installed CMake starts, use something like:

```console
$ ~/.local/xPacks/@xpack-dev-tools/cmake/{{ page.version }}-{{ page.xpack-subversion }}.1/.content/bin/cmake --version
cmake version {{ page.version }}

CMake suite maintained and supported by Kitware (kitware.com/cmake).
```

{{ manual_install }}

### Download

The GNU/Linux versions of **xPack CMake**
are packed as `.tar.gz` archives.
Download the latest version named like:

- `xpack-cmake-{{ page.version }}-{{ page.xpack-subversion }}-linux-x64.tar.gz`
- `xpack-cmake-{{ page.version }}-{{ page.xpack-subversion }}-linux-arm.tar.gz`
- `xpack-cmake-{{ page.version }}-{{ page.xpack-subversion }}-linux-arm64.tar.gz`

As the name implies, these are GNU/Linux `tar.gz` archives; they were build on
Ubuntu, but can be executed on most recent GNU/Linux distributions.

### Unpack

To manually install the xPack CMake,
unpack the archive and move it to
`~/.local/xPacks/cmake/xpack-cmake-{{ page.version }}-{{ page.xpack-subversion }}`:

```console
mkdir -p ~/.local/xPacks/cmake
cd ~/.local/xPacks/cmake

tar xvf ~/Downloads/xpack-cmake-{{ page.version }}-{{ page.xpack-subversion }}-linux-x64.tar.gz
chmod -R -w xpack-cmake-{{ page.version }}-{{ page.xpack-subversion }}
```

{% include note.html content="For manual installs, the recommended
install location is slightly different from the xpm install folders,
which use the scope (like `@xpack-dev-tools`) to group different tools,
and `.content` to store the unpacked archive." %}

```console
$ tree -L 2 '/home/ilg/.local/xPacks/cmake/xpack-cmake-{{ page.version }}-{{ page.xpack-subversion }}'
/home/ilg/.local/xPacks/cmake/xpack-cmake-{{ page.version }}-{{ page.xpack-subversion }}/
├── bin
│   ├── ccmake
│   ├── cmake
│   ├── cpack
│   └── ctest
├── distro-info
│   ├── CHANGELOG.md
│   ├── licenses
│   ├── patches
│   └── scripts
├── doc
│   └── cmake-{{ page.version-major-minor }}
├── libexec
│   ├── libcrypto.so.1.1
│   ├── libncurses.so.6 -> libncurses.so.6.2
│   ├── libncurses.so.6.2
│   └── libssl.so.1.1
├── README.md
└── share
    ├── aclocal
    ├── bash-completion
    ├── cmake-{{ page.version-major-minor }}
    ├── emacs
    └── vim

14 directories, 10 files
```

### Test

To check if the manually installed CMake starts, use something like:

```console
$ ~/.local/xPacks/cmake/xpack-cmake-{{ page.version }}-{{ page.xpack-subversion }}/bin/cmake --version
cmake version {{ page.version }}

CMake suite maintained and supported by Kitware (kitware.com/cmake).
```

{% endcapture %}

{% include platform-tabs.html %}
