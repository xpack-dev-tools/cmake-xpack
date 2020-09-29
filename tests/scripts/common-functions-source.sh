# -----------------------------------------------------------------------------
# This file is part of the xPack distribution.
#   (https://xpack.github.io)
# Copyright (c) 2020 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software 
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Common functions used in various tests.
#
# Requires 
# - app_folder_path
# - test_folder_path
# - archive_platform (win32|linux|darwin)

# -----------------------------------------------------------------------------

function run_tests()
{
  run_app "${app_folder_path}/bin/cmake" --version
  run_app "${app_folder_path}/bin/cmake" --help

  run_app "${app_folder_path}/bin/ctest" --version
  run_app "${app_folder_path}/bin/ctest" --help

  run_app "${app_folder_path}/bin/cpack" --version
  run_app "${app_folder_path}/bin/cpack" --help

  if [ -f "${app_folder_path}/bin/ccmake" ]
  then
    run_app "${app_folder_path}/bin/ccmake" --version
    run_app "${app_folder_path}/bin/ccmake" --help
  fi

  # TODO: add more, if possible.
}

# -----------------------------------------------------------------------------
