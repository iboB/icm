# Copyright (c) Borislav Stanimirov
# SPDX-License-Identifier: MIT
#
cmake_minimum_required(VERSION 3.10)

project(icm_cpu_arch-demo
    LANGUAGES C CXX
)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../..)

include(icm_cpu_arch)

icm_get_native_arch_flag(native_arch_flag)
message(STATUS "Native architecture flag: ${native_arch_flag}")

add_executable(main main.cpp)
target_compile_options(main PRIVATE ${native_arch_flag})
