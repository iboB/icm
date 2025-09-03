# Copyright (c) Borislav Stanimirov
# SPDX-License-Identifier: MIT
#
cmake_minimum_required(VERSION 3.10)

project(icm_add_lib-demo
    LANGUAGES C CXX
)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/../..)

include(icm_add_lib)

# binaries to bin so as to make Windows life easier
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

add_subdirectory(cpp-lib)
add_subdirectory(c-lib)

add_executable(main main.cpp)
target_link_libraries(main PRIVATE cpp-lib c-lib)
