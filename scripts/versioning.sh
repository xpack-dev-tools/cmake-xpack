# -----------------------------------------------------------------------------
# This file is part of the xPacks distribution.
#   (https://xpack.github.io)
# Copyright (c) 2020 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# Helper script used in the xPack build scripts. As the name implies,
# it should contain only functions and should be included with 'source'
# by the build scripts (both native and container).

# -----------------------------------------------------------------------------

function application_build_versioned_components()
{
  # Don't use a comma since the regular expression
  # that processes this string in the Makefile, silently fails and the
  # bfdver.h file remains empty.
  export XBB_BRANDING="${XBB_APPLICATION_DISTRO_NAME} ${XBB_APPLICATION_NAME} ${XBB_REQUESTED_TARGET_MACHINE}"

  # cmake_BUILD_GIT_BRANCH=${cmake_BUILD_GIT_BRANCH:-"master"}
  # cmake_BUILD_GIT_COMMIT=${cmake_BUILD_GIT_COMMIT:-"HEAD"}

  # Use this for custom content, otherwise the generic README-OUT.md
  # will be copied to the archive.
  # README_OUT_FILE_NAME=${README_OUT_FILE_NAME:-"README-${XBB_RELEASE_VERSION}.md"}

  export XBB_CMAKE_VERSION="$(echo "${XBB_RELEASE_VERSION}" | sed -e 's|-.*||')"

  # When 3.x.3 is out, release 3.x-1.y
  # Keep them in sync with combo archive content.
  if [[ "${XBB_RELEASE_VERSION}" =~ 3\.22\.* ]]
  then
    # -------------------------------------------------------------------------

    xbb_set_binaries_install "${XBB_DEPENDENCIES_INSTALL_FOLDER_PATH}"
    xbb_set_libraries_install "${XBB_DEPENDENCIES_INSTALL_FOLDER_PATH}"

    # http://zlib.net/fossils/
    zlib_build "1.2.12"

    if [ "${XBB_REQUESTED_HOST_PLATFORM}" != "win32" ]
    then
      XBB_NCURSES_DISABLE_WIDEC="y"
      # https://ftp.gnu.org/gnu/ncurses/
      ncurses_build "6.3"
    fi

    # https://sourceforge.net/projects/lzmautils/files/
    xz_build "5.2.5"

    # https://www.openssl.org/source/old/
    openssl_build "1.1.1q"


    xbb_set_binaries_install "${XBB_APPLICATION_INSTALL_FOLDER_PATH}"

    cmake_build "${XBB_CMAKE_VERSION}"

  else
    echo "Unsupported version ${XBB_RELEASE_VERSION}."
    exit 1
  fi
}

# -----------------------------------------------------------------------------
