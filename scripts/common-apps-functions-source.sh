# -----------------------------------------------------------------------------
# This file is part of the xPack distribution.
#   (https://xpack.github.io)
# Copyright (c) 2020 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software 
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# Helper script used in the second edition of the xPack build 
# scripts. As the name implies, it should contain only functions and 
# should be included with 'source' by the container build scripts.

# -----------------------------------------------------------------------------

function do_cmake()
{
  local cmake_version="$1"

  # https://cmake.org
  # https://gitlab.kitware.com/cmake/cmake
  # https://github.com/Kitware/CMake/releases/download/v3.17.1/cmake-3.17.1.tar.gz

  # https://archlinuxarm.org/packages/aarch64/cmake/files/PKGBUILD

  # The folder name as resulted after being extracted from the archive.
  local cmake_src_folder_name="cmake-${cmake_version}"
  # The folder name  for build, licenses, etc.
  local cmake_folder_name="${cmake_src_folder_name}"

  # GitHub release archive.
  local cmake_archive_file_name="${cmake_src_folder_name}.tar.gz"
  local cmake_url="https://github.com/Kitware/CMake/releases/download/v${cmake_version}/${cmake_archive_file_name}"

  cd "${SOURCES_FOLDER_PATH}"

  download_and_extract "${cmake_url}" "${cmake_archive_file_name}" \
    "${cmake_src_folder_name}"

  (
    mkdir -pv "${BUILD_FOLDER_PATH}/${cmake_folder_name}"
    cd "${BUILD_FOLDER_PATH}/${cmake_folder_name}"

    mkdir -pv "${LOGS_FOLDER_PATH}/${cmake_folder_name}"

    xbb_activate
    xbb_activate_installed_dev

    if [ "${TARGET_PLATFORM}" == "darwin" ]
    then
      # error: variably modified 'bytes' at file scope
      export CC=clang
      export CXX=clang++
    elif [ "${TARGET_PLATFORM}" == "win32" ]
    then
      prepare_cross_env "${CROSS_COMPILE_PREFIX}"
    fi

    # export CPPFLAGS="${XBB_CPPFLAGS}"
    export CFLAGS="${XBB_CPPFLAGS} ${XBB_CFLAGS}"
    export CXXFLAGS="${XBB_CPPFLAGS} ${XBB_CXXFLAGS}"
    export LDFLAGS="${XBB_CPPFLAGS} ${XBB_LDFLAGS_APP_STATIC_GCC} -v"

    env | sort

    local build_type
    if [ "${IS_DEBUG}" == "y" ]
    then
      build_type=Debug
    else
      build_type=Release
    fi

    if [ ! -f "CMakeCache.txt" ]
    then
      (
        echo
        echo "Running cmake cmake..."

        config_options=()

        if [ "${TARGET_PLATFORM}" == "win32" ]
        then
          config_options+=("-DCMAKE_SYSTEM_NAME=Windows")
        fi

        # If more verbosity is needed:
        #  -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON 
        # Disable ccmake for now
        # -DBUILD_CursesDialog=OFF
        # Disable tests
        # -DBUILD_TESTING=OFF

        # -DCMAKE_SYSTEM_NAME tricks it behave as when on Windows

        set +u

        # The mingw build also requires RC pointing to windres.
        cmake \
          -G Ninja \
          -DCMAKE_INSTALL_PREFIX="${APP_PREFIX}" \
          \
          -DCMAKE_VERBOSE_MAKEFILE=ON \
          -DCMAKE_BUILD_TYPE="${build_type}" \
          \
          -DBUILD_CursesDialog=OFF \
          \
          -DBUILD_TESTING=ON \
          ${config_options[@]} \
          \
          "${SOURCES_FOLDER_PATH}/${cmake_src_folder_name}"

        set -u

      ) 2>&1 | tee "${LOGS_FOLDER_PATH}/${cmake_folder_name}/cmake-output.txt"
    fi

    (
      echo
      echo "Running cmake build..."

      cmake \
        --build . \
        --parallel ${JOBS} \
        --config "${build_type}" \

      (
        # The install procedure runs some tests, which require
        # the libssl and libcrypt libraries from XBB.
        xbb_activate_libs

        cmake \
          --build . \
          --config "${build_type}" \
          -- \
          install

      )

      for app in cmake ctest cpack
      do
        prepare_app_libraries "${APP_PREFIX}/bin/${app}"
      done

    ) 2>&1 | tee "${LOGS_FOLDER_PATH}/${cmake_folder_name}/build-output.txt"

    copy_license \
      "${SOURCES_FOLDER_PATH}/${cmake_src_folder_name}" \
      "${cmake_folder_name}"

    (
      cd "${SOURCES_FOLDER_PATH}/${cmake_src_folder_name}/Utilities"
      for d in *
      do
        if [ -d "${d}" ]
        then
          copy_license \
            "${SOURCES_FOLDER_PATH}/${cmake_src_folder_name}/Utilities/${d}" \
            "${d}"  
        fi   
      done
    )

    # The original doc folder included licenses, which are now
    # in a separate location.
    echo
    echo "Removing the installed doc folder..."
    rm -rfv "${APP_PREFIX}/doc"

    (
      cd "${BUILD_FOLDER_PATH}/${cmake_folder_name}"

      copy_cmake_logs "${cmake_folder_name}"
    )
  )
}

# -----------------------------------------------------------------------------

function run_cmake()
{
  for app in cmake ctest cpack
  do
    run_app "${APP_PREFIX}/bin/${app}" --version
  done
}

# -----------------------------------------------------------------------------

function copy_distro_files()
{
  (
    xbb_activate

    mkdir -pv "${APP_PREFIX}/${DISTRO_INFO_NAME}"

    copy_build_files

    echo
    echo "Copying xPack files..."

    cd "${WORK_FOLDER_PATH}/build.git"
    install -v -c -m 644 "scripts/${README_OUT_FILE_NAME}" \
      "${APP_PREFIX}/README.md"
  )
}
