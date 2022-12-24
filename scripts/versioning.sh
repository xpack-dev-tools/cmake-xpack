# -----------------------------------------------------------------------------
# This file is part of the xPacks distribution.
#   (https://xpack.github.io)
# Copyright (c) 2020 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------

function application_build_versioned_components()
{
  export XBB_CMAKE_VERSION="$(echo "${XBB_RELEASE_VERSION}" | sed -e 's|-.*||')"

  # When 3.x.3 is out, release 3.x-1.y
  # Keep them in sync with combo archive content.
  if [[ "${XBB_RELEASE_VERSION}" =~ 3\.22\.* ]]
  then
    # -------------------------------------------------------------------------
    # Build the native dependencies.

    # None

    # -------------------------------------------------------------------------
    # Build the target dependencies.

    xbb_reset_env
    xbb_set_target "requested"

    xbb_set_executables_install_path "${XBB_DEPENDENCIES_INSTALL_FOLDER_PATH}"
    xbb_set_libraries_install_path "${XBB_DEPENDENCIES_INSTALL_FOLDER_PATH}"

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

    # -------------------------------------------------------------------------
    # Application binaries.

    xbb_set_executables_install_path "${XBB_APPLICATION_INSTALL_FOLDER_PATH}"
    xbb_set_libraries_install_path "${XBB_DEPENDENCIES_INSTALL_FOLDER_PATH}"

    cmake_build "${XBB_CMAKE_VERSION}"

  else
    echo "Unsupported ${XBB_APPLICATION_LOWER_CASE_NAME} version ${XBB_RELEASE_VERSION}"
    exit 1
  fi
}

# -----------------------------------------------------------------------------
