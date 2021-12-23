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

function build_versions()
{
  # Don't use a comma since the regular expression
  # that processes this string in the Makefile, silently fails and the
  # bfdver.h file remains empty.
  BRANDING="${DISTRO_NAME} ${APP_NAME} ${TARGET_MACHINE}"

  # cmake_BUILD_GIT_BRANCH=${cmake_BUILD_GIT_BRANCH:-"master"}
  # cmake_BUILD_GIT_COMMIT=${cmake_BUILD_GIT_COMMIT:-"HEAD"}

  # Use this for custom content, otherwise the generic README-OUT.md
  # will be copied to the archive.
  # README_OUT_FILE_NAME=${README_OUT_FILE_NAME:-"README-${RELEASE_VERSION}.md"}

  CMAKE_VERSION="$(echo "${RELEASE_VERSION}" | sed -e 's|-.*||')"

  if [ "${TARGET_PLATFORM}" == "win32" ]
  then
    prepare_gcc_env "${CROSS_COMPILE_PREFIX}-"
  fi

  # Keep them in sync with combo archive content.
  if [[ "${RELEASE_VERSION}" =~ 3\.20\.* ]]
  then
    # -------------------------------------------------------------------------

    if [[ "${RELEASE_VERSION}" =~ 3\.20\.6-[12] ]]
    then
      CMAKE_GIT_URL=${CMAKE_GIT_URL:-"https://github.com/xpack-dev-tools/cmake.git"}
      CMAKE_GIT_BRANCH=${CMAKE_GIT_BRANCH:-"v3.20.6-xpack"}
      CMAKE_GIT_COMMIT=${CMAKE_GIT_COMMIT:-"c90b991490abe9cbd0399e28016fa532a2b2846f"}
    else
      echo "Unsupported ${RELEASE_VERSION}"
    fi

    (
      xbb_activate

      if [ "${TARGET_PLATFORM}" != "win32" ]
      then
        NCURSES_DISABLE_WIDEC="y"
        build_ncurses "6.2"
      fi

      build_xz "5.2.5"

      build_cmake "${CMAKE_VERSION}"
    )
  elif [[ "${RELEASE_VERSION}" =~ 3\.19\.* ]]
  then
    # -------------------------------------------------------------------------

    if [ "${RELEASE_VERSION}" == "3.19.2-2" ]
    then
      CMAKE_GIT_URL=${CMAKE_GIT_URL:-"https://github.com/xpack-dev-tools/cmake.git"}
      CMAKE_GIT_BRANCH=${CMAKE_GIT_BRANCH:-"v3.19.2-xpack"}
      CMAKE_GIT_COMMIT=${CMAKE_GIT_COMMIT:-"60a09eefd8c47a2da2c3940c73761a588979ecfe"}
    elif [ "${RELEASE_VERSION}" == "3.19.8-1" ]
    then
      CMAKE_GIT_URL=${CMAKE_GIT_URL:-"https://github.com/xpack-dev-tools/cmake.git"}
      CMAKE_GIT_BRANCH=${CMAKE_GIT_BRANCH:-"v3.19.8-xpack"}
      CMAKE_GIT_COMMIT=${CMAKE_GIT_COMMIT:-"v3.19.8-xpack"}
    else
      echo "Unsupported ${RELEASE_VERSION}"
    fi

    (
      xbb_activate

      if [ "${TARGET_PLATFORM}" != "win32" ]
      then
        NCURSES_DISABLE_WIDEC="y"
        build_ncurses "6.2"
      fi

      build_xz "5.2.5"

      build_cmake "${CMAKE_VERSION}"
    )
  elif [[ "${RELEASE_VERSION}" =~ 3\.18\.* ]]
  then
    # -------------------------------------------------------------------------

    if [ "${RELEASE_VERSION}" == "3.18.6-1" ]
    then
      CMAKE_GIT_URL=${CMAKE_GIT_URL:-"https://github.com/xpack-dev-tools/cmake.git"}
      CMAKE_GIT_BRANCH=${CMAKE_GIT_BRANCH:-"v3.18.6-xpack"}
      CMAKE_GIT_COMMIT=${CMAKE_GIT_COMMIT:-"d465c152a0d9262cadbd4f942e77f322c63328b6"}
    fi

    (
      xbb_activate

      if [ "${TARGET_PLATFORM}" != "win32" ]
      then
        NCURSES_DISABLE_WIDEC="y"
        build_ncurses "6.2"
      fi

      build_cmake "${CMAKE_VERSION}"
    )

    # -------------------------------------------------------------------------
  else
    echo "Unsupported version ${RELEASE_VERSION}."
    exit 1
  fi
}

# -----------------------------------------------------------------------------
