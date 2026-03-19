# Copyright (c) Borislav Stanimirov
# SPDX-License-Identifier: MIT
#
cmake_minimum_required(VERSION 3.24)

project(icm_dev_mode-demo
    LANGUAGES C CXX
)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../..)

set(ICM_DEV_CXX_STANDARD 23)
include(icm_dev_mode)

add_executable(dev_mode_demo dev_mode_demo.cpp)
