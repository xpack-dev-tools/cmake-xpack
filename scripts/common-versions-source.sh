# -----------------------------------------------------------------------------
# This file is part of the xPacks distribution.
#   (https://xpack.github.io)
# Copyright (c) 2020 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software 
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# Helper script used in the second edition of the GNU MCU Eclipse build 
# scripts. As the name implies, it should contain only functions and 
# should be included with 'source' by the container build scripts.

# -----------------------------------------------------------------------------

function do_build_versions()
{
  # The \x2C is a comma in hex; without this trick the regular expression
  # that processes this string in the Makefile, silently fails and the 
  # bfdver.h file remains empty.
  BRANDING="${BRANDING}\x2C ${TARGET_MACHINE}"

  # cmake_BUILD_GIT_BRANCH=${cmake_BUILD_GIT_BRANCH:-"master"}
  # cmake_BUILD_GIT_COMMIT=${cmake_BUILD_GIT_COMMIT:-"HEAD"}

  # Use this for custom content, otherwise the generic README-OUT.md 
  # will be copied to the archive.
  # README_OUT_FILE_NAME=${README_OUT_FILE_NAME:-"README-${RELEASE_VERSION}.md"}

  USE_TAR_GZ=${USE_TAR_GZ:-"y"}
  USE_SINGLE_FOLDER_PATH=${USE_SINGLE_FOLDER_PATH:-"y"}

  # Keep them in sync with combo archive content.
  if [[ "${RELEASE_VERSION}" =~ 3\.17\.1-1 ]]
  then

    # -------------------------------------------------------------------------

    if [ "${TARGET_PLATFORM}" != "win32" ]
    then
      NCURSES_DISABLE_WIDEC="y"
      do_ncurses "6.2"
    fi

    (
      xbb_activate
      # TODO: remove after updating XBB to include it.
      # pip3 install --user sphinx
      pip3 install sphinx
    )

    do_cmake "3.17.1"

    # -------------------------------------------------------------------------
  else
    echo "Unsupported version ${RELEASE_VERSION}."
    exit 1
  fi
}

# -----------------------------------------------------------------------------
