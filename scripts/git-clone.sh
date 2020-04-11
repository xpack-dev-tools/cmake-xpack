#!/usr/bin/env bash
rm -rf "${HOME}/Downloads/cmake-xpack.git"
git clone \
  --recurse-submodules \
  https://github.com/xpack-dev-tools/cmake-xpack.git \
  "${HOME}/Downloads/cmake-xpack.git"
