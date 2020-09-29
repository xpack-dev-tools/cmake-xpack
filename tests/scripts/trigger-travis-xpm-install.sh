#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# This file is part of the xPack distribution.
#   (https://xpack.github.io)
# Copyright (c) 2020 Liviu Ionescu.
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

script_path="$0"
if [[ "${script_path}" != /* ]]
then
  # Make relative path absolute.
  script_path="$(pwd)/$0"
fi

script_name="$(basename "${script_path}")"

script_folder_path="$(dirname "${script_path}")"
script_folder_name="$(basename "${script_folder_path}")"

# =============================================================================

source "${script_folder_path}/app-defs.sh"

helper_folder_path="$(dirname $(dirname "${script_folder_path}"))/scripts/helper"

source "${helper_folder_path}/test-functions-source.sh"

# -----------------------------------------------------------------------------

message="Test xpm install"
branch="xpack-develop"

data_file_path="$(mktemp)"

create_xpm_install_data_file "${message}" "${branch}" "${data_file_path}"

# https://docs.travis-ci.com/user/triggering-builds/

# TRAVIS_ORG_TOKEN must be present in the environment.
trigger_travis "${github_org}" "${github_repo}" "${data_file_path}"

cat "${data_file_path}"
rm -v "${data_file_path}"

echo "Done."

# -----------------------------------------------------------------------------
