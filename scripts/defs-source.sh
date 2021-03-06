# -----------------------------------------------------------------------------
# This file is part of the xPack distribution.
#   (https://xpack.github.io)
# Copyright (c) 2020 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software 
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# Helper script used in the second edition of the build scripts.
# As the name implies, it should contain only definitions and should
# be included with 'source' by the host and container scripts.

# Warning: MUST NOT depend on $HOME or other environment variables.

# -----------------------------------------------------------------------------

# Used to display the application name.
APP_NAME=${APP_NAME:-"CMake"}

# Used as part of file/folder paths.
APP_LC_NAME=${APP_LC_NAME:-"cmake"}

DISTRO_UC_NAME=${DISTRO_UC_NAME:-"xPack"}
DISTRO_LC_NAME=${DISTRO_LC_NAME:-"xpack"}
DISTRO_TOP_FOLDER=${DISTRO_TOP_FOLDER:-"xPacks"}

# Use the new xPack naming convention.
HAS_NAME_ARCH="y"

BRANDING=${BRANDING:-"${DISTRO_UC_NAME} ${APP_NAME}"}

CONTAINER_SCRIPT_NAME=${CONTAINER_SCRIPT_NAME:-"container-build.sh"}

COMMON_LIBS_FUNCTIONS_SCRIPT_NAME=${COMMON_LIBS_FUNCTIONS_SCRIPT_NAME:-"common-libs-functions-source.sh"}
COMMON_APPS_FUNCTIONS_SCRIPT_NAME=${COMMON_APPS_FUNCTIONS_SCRIPT_NAME:-"common-apps-functions-source.sh"}

# -----------------------------------------------------------------------------
