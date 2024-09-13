# -----------------------------------------------------------------------------
# This file is part of the xPack distribution.
#   (https://xpack.github.io)
# Copyright (c) 2020 Liviu Ionescu. All rights reserved.
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Run all application tests.

function tests_run_all()
{
  echo
  echo "[${FUNCNAME[0]} $@]"

  local test_bin_path="$1"

  XBB_CMAKE_VERSION="$(xbb_strip_version_pre_release "${XBB_RELEASE_VERSION}")"

  if [ ! -d "${XBB_SOURCES_FOLDER_PATH}/cmake-${XBB_CMAKE_VERSION}" ]
  then
      if true
      then
        local cmake_src_folder_name="cmake-${XBB_CMAKE_VERSION}"

        local cmake_archive="${cmake_src_folder_name}.tar.gz"
        local cmake_url="https://github.com/Kitware/CMake/releases/download/v{$XBB_CMAKE_VERSION}/${cmake_archive}"

        (
          cd "${XBB_SOURCES_FOLDER_PATH}"

          download_and_extract "${cmake_url}" "${cmake_archive}" \
            "${cmake_src_folder_name}"
        )
      else
        XBB_CMAKE_GIT_URL=${XBB_CMAKE_GIT_URL:-"https://github.com/xpack-dev-tools/cmake.git"}
        XBB_CMAKE_GIT_BRANCH=${XBB_CMAKE_GIT_BRANCH:-"v${XBB_CMAKE_VERSION}-xpack"}
        XBB_CMAKE_GIT_COMMIT=${XBB_CMAKE_GIT_COMMIT:-"v${XBB_CMAKE_VERSION}-xpack"}
        (
          mkdir -pv "${XBB_SOURCES_FOLDER_PATH}"
          cd "${XBB_SOURCES_FOLDER_PATH}"

          run_verbose git_clone \
            "${XBB_CMAKE_GIT_URL}" \
            "cmake-${XBB_CMAKE_VERSION}" \
            --branch="${XBB_CMAKE_GIT_BRANCH}" \
            --commit="${XBB_CMAKE_GIT_COMMIT}" \
        )
      fi
  fi

  echo
  env | sort

  cmake_test "${test_bin_path}"
}

# -----------------------------------------------------------------------------
