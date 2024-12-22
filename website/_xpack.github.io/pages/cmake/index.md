---

title: The xPack CMake
permalink: /dev-tools/cmake/

summary: "A binary distribution of CMake."

keywords: cmake

comments: true

date: 2020-09-29 14:05:00 +0300

redirect_to: https://xpack-dev-tools.github.io/cmake-xpack/

---

## Quicklinks

If you already know the general facts about the xPack CMake, you can
directly skip to the desired pages.

User pages:

- [install]({{ site.baseurl }}/cmake/install/)
- [support]({{ site.baseurl }}/cmake/support/)
- [releases]({{ site.baseurl }}/cmake/releases/)

Developer & maintainer pages:

- [GitHub](https://github.com/xpack-dev-tools/cmake-xpack/)
- [README-MAINTAINER](https://github.com/xpack-dev-tools/cmake-xpack/blob/xpack/README-MAINTAINER.md)

## Overview

The **xPack CMake** is a cross-platform binary distribution of the
[CMake](https://cmake.org) build system,
an open source project hosted on
[GitLab](https://gitlab.kitware.com/cmake/cmake).

## Benefits

The main advantages of using the **xPack CMake** are:

- a convenient, uniform and portable install/uninstall/upgrade procedure,
  the same procedure is used for all major
  platforms (Intel Windows 64-bit, Intel GNU/Linux 64-bit, Arm GNU/Linux
  64/32-bit, Intel macOS 64-bit, Apple Silicon macOS 64-bit)
- a better integration with development environments
- a more convenient integration with CI environment

All binaries are self-contained, they include all required libraries,
and can be installed in any location.

## Compatibility

The **xPack CMake** is fully compatible with the original **CMake**
distribution.

## Install

The details of installing the **xPack CMake** on various platforms are
presented in the separate
[install]({{ site.baseurl }}/cmake/install/) page.

## Documentation

The current version specific CMake documentation is available online from:

- [https://cmake.org/documentation/](https://cmake.org/documentation/)

## Support

For the various support options, please read the separate
[support]({{ site.baseurl }}/cmake/support/) page.

## Change log

The release and change log is available in the repository
[`CHANGELOG.md`](https://github.com/xpack-dev-tools/cmake-xpack/blob/xpack/CHANGELOG.md) file.

## Build details

For those interested in building the binaries, please read the
[README-MAINTAINER](https://github.com/xpack-dev-tools/cmake-xpack/blob/xpack/README-MAINTAINER.md)
page.
However, the ultimate source for details are the build scripts themselves,
all available from the
[`cmake-xpack.git/scripts`](https://github.com/xpack-dev-tools/cmake-xpack/tree/xpack/scripts/)
folder.

## Releases

See the [releases]({{ site.baseurl }}/cmake/releases/) pages.
