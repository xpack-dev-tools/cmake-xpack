# -----------------------------------------------------------------------------
# This file is part of the xPack distribution.
#   (https://xpack.github.io)
# Copyright (c) 2020 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Run all application tests.

function tests_run_all()
{
  local test_bin_path="$1"

  XBB_CMAKE_VERSION="$(echo "${XBB_RELEASE_VERSION}" | sed -e 's|-.*||')"

  if [ ! -d "${XBB_SOURCES_FOLDER_PATH}/cmake-${XBB_CMAKE_VERSION}" ]
  then
      XBB_CMAKE_GIT_URL=${XBB_CMAKE_GIT_URL:-"https://github.com/xpack-dev-tools/cmake.git"}
      XBB_CMAKE_GIT_BRANCH=${XBB_CMAKE_GIT_BRANCH:-"v${XBB_CMAKE_VERSION}-xpack"}
      XBB_CMAKE_GIT_COMMIT=${XBB_CMAKE_GIT_COMMIT:-"v${XBB_CMAKE_VERSION}-xpack"}
      (
        mkdir -pv "${XBB_SOURCES_FOLDER_PATH}"
        cd "${XBB_SOURCES_FOLDER_PATH}"

        git_clone "${XBB_CMAKE_GIT_URL}" "${XBB_CMAKE_GIT_BRANCH}" \
            "${XBB_CMAKE_GIT_COMMIT}" "cmake-${XBB_CMAKE_VERSION}"
      )
  fi

  echo
  env | sort

  cmake_test "${test_bin_path}"
}

# -----------------------------------------------------------------------------
