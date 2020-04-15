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
# - app_absolute_folder_path
# - test_absolute_folder_path
# - archive_platform (win32|linux|darwin)

# -----------------------------------------------------------------------------

function run_tests()
{
  run_app "${app_absolute_folder_path}/bin/cmake" --version
  run_app "${app_absolute_folder_path}/bin/ctest" --version
  run_app "${app_absolute_folder_path}/bin/cpack" --version

  if [ -f "${app_absolute_folder_path}/bin/ccmake" ]
  then
    run_app "${app_absolute_folder_path}/bin/ccmake" --version
  fi

  # TODO: add more, if possible.
}

# -----------------------------------------------------------------------------
