#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# This file is part of the xPack distribution.
#   (https://xpack.github.io)
# Copyright (c) 2022 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Safety settings (see https://gist.github.com/ilg-ul/383869cbb01f61a51c4d).

if [[ ! -z ${DEBUG} ]]
then
  set ${DEBUG} # Activate the expand mode if DEBUG is anything but empty.
else
  DEBUG=""
fi

set -o errexit # Exit if command failed.
set -o pipefail # Exit if pipe failed.
set -o nounset # Exit if variable not set.

# Remove the initial space and instead use '\n'.
IFS=$'\n\t'

# -----------------------------------------------------------------------------
# Identify the script location, to reach, for example, the helper scripts.

build_script_path="$0"
if [[ "${build_script_path}" != /* ]]
then
  # Make relative path absolute.
  build_script_path="$(pwd)/$0"
fi

script_folder_path="$(dirname "${build_script_path}")"
script_folder_name="$(basename "${script_folder_path}")"

# =============================================================================

scripts_folder_path="${script_folder_path}"
project_folder_path="$(dirname ${script_folder_path})"
helper_folder_path="${project_folder_path}/xpacks/xpack-dev-tools-xbb-helper"

# -----------------------------------------------------------------------------

source "${scripts_folder_path}/definitions.sh"
source "${helper_folder_path}/scripts/build.sh"
source "${scripts_folder_path}/versioning.sh"

source "${scripts_folder_path}/dependencies/cmake.sh"
source "${helper_folder_path}/scripts/dependencies/ncurses.sh"
source "${helper_folder_path}/scripts/dependencies/xz.sh"

# -----------------------------------------------------------------------------

help_message="    bash $0 [--win] [--debug] [--develop] [--jobs N] [--help]"
build_parse_options "${help_message}" "$@"

build_perform_common

exit 0

# -----------------------------------------------------------------------------
