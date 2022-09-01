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
  local cmake_version="$1"

  # https://cmake.org
  # https://gitlab.kitware.com/cmake/cmake
  # https://github.com/Kitware/CMake/releases
  # https://github.com/Kitware/CMake/releases/download/v3.21.6/cmake-3.21.6.tar.gz

  # https://archlinuxarm.org/packages/aarch64/cmake/files/PKGBUILD

  # 22 Sep 2020, "3.18.3"

  # Do not make them local!
  # The folder name as resulted after being extracted from the archive.
  local cmake_src_folder_name="cmake-${cmake_version}"

  local cmake_archive="${cmake_src_folder_name}.tar.gz"
  local cmake_url="https://github.com/Kitware/CMake/releases/download/v{$cmake_version}/${cmake_archive}"

  # The folder name  for build, licenses, etc.
  local cmake_folder_name="${cmake_src_folder_name}"

  mkdir -pv "${LOGS_FOLDER_PATH}/${cmake_folder_name}"

  local cmake_patch_file_name="cmake-${cmake_version}.git.patch"
  local cmake_stamp_file_path="${INSTALL_FOLDER_PATH}/stamp-${cmake_folder_name}-installed"
  if [ ! -f "${cmake_stamp_file_path}" ]
  then

    cd "${SOURCES_FOLDER_PATH}"

    if [ ! -d "${SOURCES_FOLDER_PATH}/${cmake_src_folder_name}" ]
    then
      (
        if [ ! -z ${CMAKE_GIT_URL+x} ]
        then
          cd "${SOURCES_FOLDER_PATH}"
          git_clone "${CMAKE_GIT_URL}" "${CMAKE_GIT_BRANCH}" \
              "${CMAKE_GIT_COMMIT}" "${cmake_src_folder_name}"
        else
          download_and_extract "${cmake_url}" "${cmake_archive}" \
            "${cmake_src_folder_name}" "${cmake_patch_file_name}"
        fi
      )
    fi

    (
      mkdir -pv "${BUILD_FOLDER_PATH}/${cmake_folder_name}"
      cd "${BUILD_FOLDER_PATH}/${cmake_folder_name}"

      xbb_activate_installed_dev

      CFLAGS="$(echo ${XBB_CPPFLAGS} ${XBB_CFLAGS} | sed -e 's|-O[0123s]||')"
      CXXFLAGS="$(echo ${XBB_CPPFLAGS} ${XBB_CFLAGS} | sed -e 's|-O[0123s]||')"

      LDFLAGS="$(echo ${XBB_CPPFLAGS} ${XBB_LDFLAGS_APP_STATIC_GCC} | sed -e 's|-O[0123s]||')"
      if [ "${TARGET_PLATFORM}" == "linux" ]
      then
        LDFLAGS+=" -Wl,-rpath,${LD_LIBRARY_PATH}"
      fi

      if [ "${TARGET_PLATFORM}" == "darwin" ]
      then
        # With gcc-xbb it fails with:
        # Authorization.h:193:14: error: variably modified ‘bytes’ at file scope
        export CC=clang
        export CXX=clang++
        # clang: error: unsupported option '-static-libgcc'
        LDFLAGS=$(echo ${LDFLAGS} | sed -e 's|-static-libgcc||')
      fi

      export CFLAGS
      export CXXFLAGS
      export LDFLAGS

      local build_type
      if [ "${IS_DEBUG}" == "y" ]
      then
        build_type=Debug
      else
        build_type=Release
      fi

      if true # [ ! -f "CMakeCache.txt" ]
      then
        (
          if [ "${IS_DEVELOP}" == "y" ]
          then
            env | sort
          fi

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

          # config_options+=("-DBUILD_TESTING=ON")
          config_options+=("-DBUILD_TESTING=OFF")

          if [ "${TARGET_PLATFORM}" == "win32" ]
          then
            config_options+=("-DCMAKE_SYSTEM_NAME=Windows")

            config_options+=("-DCMake_RUN_CXX_FILESYSTEM=0")
            config_options+=("-DCMake_RUN_CXX_FILESYSTEM__TRYRUN_OUTPUT=")

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

            # Hack: Otherwise the configure step fails with:
            # CMake Error at CMakeLists.txt:107 (message):
            # The C++ compiler does not support C++11 (e.g.  std::unique_ptr).
            config_options+=("-DCMake_HAVE_CXX_UNIQUE_PTR=ON")
          elif [ "${TARGET_PLATFORM}" == "linux" ]
          then
            config_options+=("-DBUILD_CursesDialog=ON")
            config_options+=("-DCurses_ROOT=${LIBS_INSTALL_FOLDER_PATH}")
          fi

          # Warning: Expensive, it adds about 30 MB of files to the archive.
          if [ "${WITH_HTML}" == "y" ]
          then
            config_options+=("-DSPHINX_HTML=ON")
          else
            config_options+=("-DSPHINX_HTML=OFF")
          fi

          config_options+=("-DCPACK_BINARY_7Z=ON")
          config_options+=("-DCPACK_BINARY_ZIP=ON")

          config_options+=("-DCMAKE_INSTALL_PREFIX=${APP_PREFIX}")

          # The mingw build also requires RC pointing to windres.
          run_verbose_timed cmake \
            "${config_options[@]}" \
            \
            "${SOURCES_FOLDER_PATH}/${cmake_src_folder_name}"

        ) 2>&1 | tee "${LOGS_FOLDER_PATH}/${cmake_folder_name}/cmake-output.txt"
      fi

      (
        echo
        echo "Running cmake build..."

        if [ "${IS_DEVELOP}" == "y" ]
        then
          run_verbose_timed cmake \
            --build . \
            --parallel ${JOBS} \
            --verbose \
            --config "${build_type}"
        else
          run_verbose_timed cmake \
            --build . \
            --parallel ${JOBS} \
            --config "${build_type}"
        fi

        (
          # The install procedure runs some resulted executables, which require
          # the libssl and libcrypt libraries from XBB.
          xbb_activate_libs

          echo
          echo "Running cmake install..."

          run_verbose_timed cmake \
            --build . \
            --config "${build_type}" \
            -- \
            install

        )

      ) 2>&1 | tee "${LOGS_FOLDER_PATH}/${cmake_folder_name}/build-output.txt"

      copy_license \
        "${SOURCES_FOLDER_PATH}/${cmake_src_folder_name}" \
        "${cmake_folder_name}"

      (
        cd "${BUILD_FOLDER_PATH}"

        copy_cmake_logs "${cmake_folder_name}"
      )
    )

    touch "${cmake_stamp_file_path}"

  else
    echo "Component cmake already installed."
  fi

  tests_add "test_cmake"
}

# -----------------------------------------------------------------------------

function test_cmake()
{
  echo
  echo "Running the binaries..."

  if [ -d "xpacks/.bin" ]
  then
    TEST_BIN_PATH="$(pwd)/xpacks/.bin"
  elif [ -d "${APP_PREFIX}/bin" ]
  then
    TEST_BIN_PATH="${APP_PREFIX}/bin"
  else
    echo "Wrong folder."
    exit 1
  fi

  apps_names=("cmake" "ctest" "cpack")
  if [ "${TARGET_PLATFORM}" != "win32" ]
  then
    apps_names+=("ccmake")
  fi

  for app in ${apps_names[@]}
  do
    run_app "${TEST_BIN_PATH}/${app}" --version
    run_app "${TEST_BIN_PATH}/${app}" --help
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

      if [ "${IS_DEVELOP}" == "y" ]
      then
        env | sort
      fi

      echo
      echo "Testing if it can generate itself..."

      # xbb_activate
      run_app "${TEST_BIN_PATH}/cmake" \
        "-DCMAKE_USE_OPENSSL=OFF" \
        "${SOURCES_FOLDER_PATH}/cmake-${CMAKE_VERSION}"
    )
  fi

  echo
  echo "Local tests completed successfuly."
}

# -----------------------------------------------------------------------------
