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
source "${script_folder_path}/common-functions-source.sh"

# -----------------------------------------------------------------------------

force_32_bit=""
if [ "$1" == "--32" ]
then
  force_32_bit="y"
  shift
fi

base_url="$1"
echo "${base_url}"
shift

while [ $# -gt 0 ]
do
  case "$1" in

    -*)
      echo "Unsupported option $1."
      exit 1
      ;;

  esac
done

echo "${base_url}"

# -----------------------------------------------------------------------------

detect_architecture

prepare_env "$(dirname $(dirname "${script_folder_path}"))"

install_archive

run_tests

good_bye

# Completed successfully.
exit 0

# -----------------------------------------------------------------------------
