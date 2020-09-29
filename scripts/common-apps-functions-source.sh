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

function build_cmake()
{
  # Do not make it local!
  CMAKE_VERSION="$1"

  # https://cmake.org
  # https://gitlab.kitware.com/cmake/cmake
  # https://github.com/Kitware/CMake/releases
  # https://github.com/Kitware/CMake/releases/download/v3.17.1/cmake-3.17.1.tar.gz
  # https://github.com/Kitware/CMake/releases/download/v3.18.3/cmake-3.18.3.tar.gz

  # https://archlinuxarm.org/packages/aarch64/cmake/files/PKGBUILD

  # 22 Sep 2020, "3.18.3"

  # Do not make them local!
  # The folder name as resulted after being extracted from the archive.
  CMAKE_SRC_FOLDER_NAME="cmake-${CMAKE_VERSION}"
  # The folder name  for build, licenses, etc.
  CMAKE_FOLDER_NAME="${CMAKE_SRC_FOLDER_NAME}"

  # GitHub release archive.
  local cmake_archive_file_name="${CMAKE_SRC_FOLDER_NAME}.tar.gz"
  local cmake_url="https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/${cmake_archive_file_name}"

  local cmake_stamp_file_path="${INSTALL_FOLDER_PATH}/stamp-${CMAKE_FOLDER_NAME}-installed"

  if [ ! -f "${cmake_stamp_file_path}" ]
  then

    cd "${SOURCES_FOLDER_PATH}"

    download_and_extract "${cmake_url}" "${cmake_archive_file_name}" \
      "${CMAKE_SRC_FOLDER_NAME}"

    (
      mkdir -pv "${BUILD_FOLDER_PATH}/${CMAKE_FOLDER_NAME}"
      cd "${BUILD_FOLDER_PATH}/${CMAKE_FOLDER_NAME}"

      mkdir -pv "${LOGS_FOLDER_PATH}/${CMAKE_FOLDER_NAME}"

      xbb_activate
      xbb_activate_installed_dev

      if [ "${TARGET_PLATFORM}" == "darwin" ]
      then
        # error: variably modified 'bytes' at file scope
        export CC=clang
        export CXX=clang++
      elif [ "${TARGET_PLATFORM}" == "win32" ]
      then
        prepare_gcc_env "${CROSS_COMPILE_PREFIX}-"
      fi

      CFLAGS="${XBB_CPPFLAGS} ${XBB_CFLAGS}"
      CXXFLAGS="${XBB_CPPFLAGS} ${XBB_CXXFLAGS}"
      LDFLAGS="${XBB_CPPFLAGS} ${XBB_LDFLAGS_APP_STATIC_GCC} -v"

      export CFLAGS
      export CXXFLAGS
      export LDFLAGS

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

          # If more verbosity is needed:
          #  -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON 
          # Disable ccmake for now
          # -DBUILD_CursesDialog=OFF
          # Disable tests
          # -DBUILD_TESTING=OFF

          # -DCMAKE_SYSTEM_NAME tricks it behave as when on Windows

          # -DBUILD_CursesDialog=ON 
          # -DCMAKE_PREFIX_PATH="${LIBS_INSTALL_FOLDER_PATH}" \

          config_options+=("-G" "Ninja")
            
          config_options+=("-DCMAKE_VERBOSE_MAKEFILE=ON")
          config_options+=("-DCMAKE_BUILD_TYPE=${build_type}")
            
          config_options+=("-DBUILD_TESTING=ON")

          if [ "${TARGET_PLATFORM}" == "win32" ]
          then
            config_options+=("-DCMAKE_SYSTEM_NAME=Windows")

            # Windows does not need ncurses, since ccmake is not built.
          elif [ "${TARGET_PLATFORM}" == "darwin" ]
          then
            # Hack
            # https://gitlab.kitware.com/cmake/cmake/-/issues/20570#note_732291
            config_options+=("-DBUILD_CursesDialog=ON")

            # To search all packages in the given path:
            # config_options+=("-DCMAKE_PREFIX_PATH=${LIBS_INSTALL_FOLDER_PATH}")
            
            # To search only curses in the given path:
            config_options+=("-DCurses_ROOT=${LIBS_INSTALL_FOLDER_PATH}")
          elif [ "${TARGET_PLATFORM}" == "linux" ]
          then
            config_options+=("-DBUILD_CursesDialog=ON")
            config_options+=("-DCurses_ROOT=${LIBS_INSTALL_FOLDER_PATH}")
          fi

          # Warning: Expensive, it adds about 30 MB of files to the archive.
          config_options+=("-DSPHINX_HTML=ON")

          # The mingw build also requires RC pointing to windres.
          cmake \
            -DCMAKE_INSTALL_PREFIX="${APP_PREFIX}" \
            \
            ${config_options[@]} \
            \
            "${SOURCES_FOLDER_PATH}/${CMAKE_SRC_FOLDER_NAME}"

        ) 2>&1 | tee "${LOGS_FOLDER_PATH}/${CMAKE_FOLDER_NAME}/cmake-output.txt"
      fi

      (
        echo
        echo "Running cmake build..."

        cmake \
          --build . \
          --parallel ${JOBS} \
          --config "${build_type}" \

        (
          # The install procedure runs some resulted exxecutables, which require
          # the libssl and libcrypt libraries from XBB.
          xbb_activate_libs

          echo
          echo "Running cmake install..."

          cmake \
            --build . \
            --config "${build_type}" \
            -- \
            install

        )

        prepare_app_names

        for app in ${apps_names[@]}
        do
          prepare_app_libraries "${APP_PREFIX}/bin/${app}"
        done

      ) 2>&1 | tee "${LOGS_FOLDER_PATH}/${CMAKE_FOLDER_NAME}/build-output.txt"

      copy_license \
        "${SOURCES_FOLDER_PATH}/${CMAKE_SRC_FOLDER_NAME}" \
        "${CMAKE_FOLDER_NAME}"

      (
        cd "${BUILD_FOLDER_PATH}"

        copy_cmake_logs "${CMAKE_FOLDER_NAME}"
      )
    )

    touch "${cmake_stamp_file_path}"

  else
    echo "Component cmake stage already installed."
  fi

  tests_add "test_cmake"
}

function prepare_app_names()
{
  apps_names=("cmake" "ctest" "cpack")
  if [ "${TARGET_PLATFORM}" != "win32" ]
  then
    apps_names+=("ccmake")
  fi
}


# -----------------------------------------------------------------------------

function test_cmake()
{
  echo
  echo "Running the binaries..."

  prepare_app_names

  for app in ${apps_names[@]}
  do
    run_app "${APP_PREFIX}/bin/${app}" --version
  done

  # ---------------------------------------------------------------------------

  # cmake is not happy when started via wine, since it tries to
  # execute various other tools (like it tries to get the version of ninja).
  if [ "${TARGET_PLATFORM}" != "win32" ]
  then
    (
      local test_folder_path="$(mktemp /tmp/cmake-test-itself.XXXXX)"

      # Simple test, generate itself.
      rm -rf "${test_folder_path}"
      mkdir -pv "${test_folder_path}"

      cd "${test_folder_path}"

      echo 
      echo "Testing if it can generate itself..."

      xbb_activate
      run_app "${APP_PREFIX}/bin/cmake" \
        -G Ninja \
        -DCMAKE_PREFIX_PATH=${XBB_FOLDER_PATH} \
        "${SOURCES_FOLDER_PATH}/${CMAKE_SRC_FOLDER_NAME}"
    )
  fi

  echo
  echo "Local tests completed successfuly."
}

# -----------------------------------------------------------------------------
