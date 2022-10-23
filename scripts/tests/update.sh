# -----------------------------------------------------------------------------
# This file is part of the xPack distribution.
#   (https://xpack.github.io)
# Copyright (c) 2020 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Update the system running the tests with application specific prerequisites.

function tests_update_system()
{
  local image_name="$1"

  # Make sure that the minimum prerequisites are met.
  # For cmake to generate itself, the c++ compiler and make are needed.
  if [[ ${image_name} == github-actions-ubuntu* ]]
  then
    : # sudo apt-get -qq install -y XXX
  elif [[ ${image_name} == *ubuntu* ]] || [[ ${image_name} == *debian* ]] || [[ ${image_name} == *raspbian* ]]
  then
    run_verbose apt-get -qq install -y libc6-dev libstdc++6
    run_verbose apt-get -qq install -y build-essential
  elif [[ ${image_name} == *centos* ]] || [[ ${image_name} == *redhat* ]] || [[ ${image_name} == *fedora* ]]
  then
    run_verbose yum install -y -q glibc-devel libstdc++-devel
    run_verbose yum install -y -q gcc gcc-c++ make
  elif [[ ${image_name} == *suse* ]]
  then
    run_verbose zypper -q --no-gpg-checks in -y glibc-devel libstdc++6
    run_verbose zypper -q --no-gpg-checks in -y gcc gcc-c++ make
  elif [[ ${image_name} == *manjaro* ]]
  then
    run_verbose pacman -S -q --noconfirm --noprogressbar gcc-libs 
    run_verbose pacman -S -q --noconfirm --noprogressbar gcc make
  elif [[ ${image_name} == *archlinux* ]]
  then
    run_verbose pacman -S -q --noconfirm --noprogressbar gcc-libs
    run_verbose pacman -S -q --noconfirm --noprogressbar gcc make
  fi
}

# -----------------------------------------------------------------------------
