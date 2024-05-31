# icm_dev_mode
#
# SPDX-License-Identifier: MIT
# MIT License:
# Copyright (c) 2020-2023 Borislav Stanimirov
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files(the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and / or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions :
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT.IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#           VERSION HISTORY
#
#   1.11 (2023-10-17) Slash (/) to dash (-) for MSVC options so as to enable
#                     -forward-unknown-to-host-compiler when using nvcc
#   1.10 (2023-07-13) /Zc:templateScope for MSVC
#                     minor code reorder
#   1.09 (2023-07-13) Set USE_FOLDERS to ON
#   1.08 (2023-04-29) Improved (idiomatic) setting of compiler options
#   1.07 (2023-03-20) Improved sanitizer support: finer grain selection
#                     MSVC /W4 by default
#   1.06 (2023-02-02) C standard
#                     MSVC asan support
#                     More MSVC warnings and flags
#   1.05 (2022-06-15) Emabled more potentially useful L4 warnings for msvc.
#                     Set CMAKE_LINK_DEPENDS_NO_SHARED to ON
#   1.04 (2021-09-28) /permissive- for msvc
#   1.03 (2021-02-09) Fixed ICM_DEV_MODE setting for subdirs within other
#                     icm_dev_mode-enabled subdirs
#   1.02 (2021-01-22) Enable MSVC unused argument warning with /W3
#   1.01 (2021-01-12) Fixed check for SAN_* options
#                     Removed warning disable which was left in by mistake
#   1.00 (2020-12-25) Initial standalone release
#
#           DOCUMENTATION
#
# A dev-mode module. Include in a project to activate a set of common
# configuration settings if the project is configured from a the root.
#
# Otherwise the assumption is that the project is a subdirectory and its root
# is responsible for the configuration.
#
# You can disable to auto-configuration even from root level by setting
# ICM_NO_DEVMODE to TRUE
#
# The settings are:
# * C++ standard (default is 17. Override with ICM_DEV_CXX_STANDARD)
# * C standard (default is 99. Override with ICM_DEV_C_STANDARD)
# * No extensions
# * Standard required
# * More warnigns for gcc and clang
# * /permissive- for msvc
# * Disable some overly aggressive warnings for msvc
# * Enable potentially useful L4 warnings for msvc
# * options SAN_THREAD and SAN_ADDR (only one or zero of them must be ON)
#   to enable thread and address sanitizers
# * set runtime out directory to bin (useful for msvc so dlls are next to exes)
# * CMAKE_LINK_DEPENDS_NO_SHARED to ON

if (NOT CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    set(ICM_DEV_MODE OFF)
    return()
endif()

if (ICM_NO_DEVMODE)
    set(ICM_DEV_MODE OFF)
    return()
endif()

set(ICM_DEV_MODE ON)

# standard
if (NOT ICM_DEV_CXX_STANDARD)
    set(ICM_DEV_CXX_STANDARD 17)
endif()
set(CMAKE_CXX_STANDARD ${ICM_DEV_CXX_STANDARD})
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if (NOT ICM_DEV_C_STANDARD)
    set(ICM_DEV_C_STANDARD 99)
endif()
set(CMAKE_C_STANDARD ${ICM_DEV_C_STANDARD})
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_C_STANDARD_REQUIRED ON)

# misc config
set(CMAKE_LINK_DEPENDS_NO_SHARED ON) # only relink exe if .so interface changes
set_property(GLOBAL PROPERTY USE_FOLDERS ON) # use solution folders
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin) # binaries to bin

if(MSVC)
    # /Zc:preprocessor - incompatible with Windows.h
    add_compile_options(
        -W4
        -D_CRT_SECURE_NO_WARNINGS -Zc:__cplusplus -permissive-
        -volatile:iso -Zc:throwingNew -Zc:templateScope -utf-8 -DNOMINMAX=1
        -wd4251 -wd4275
    )
else()
    add_compile_options(-Wall -Wextra)
endif()

# sanitizers
option(SAN_THREAD "${CMAKE_PROJECT_NAME}: sanitize thread" OFF)
option(SAN_ADDR "${CMAKE_PROJECT_NAME}: sanitize address" OFF)
option(SAN_UB "${CMAKE_PROJECT_NAME}: sanitize undefined behavior" OFF)
option(SAN_LEAK "${CMAKE_PROJECT_NAME}: sanitize leaks" OFF)

if(MSVC)
    if(SAN_ADDR)
        add_compile_options(-fsanitize=address)
    endif()
    if(SAN_THREAD OR SAN_UB OR SAN_LEAK)
        message(WARNING "Unsupported sanitizers requested for msvc. Ignored")
    endif()
else()
    if(SAN_THREAD)
        set(icm_san_flags -fsanitize=thread -g)
        if(SAN_ADDR OR SAN_UB OR SAN_LEAK)
            message(WARNING "Incompatible sanitizer combination requested. Only 'SAN_THREAD' will be respected")
        endif()
    else()
        if(SAN_ADDR)
            list(APPEND icm_san_flags -fsanitize=address -pthread)
        endif()
        if(SAN_UB)
            list(APPEND icm_san_flags -fsanitize=undefined)
        endif()
        if(SAN_LEAK)
            if(APPLE)
                message(WARNING "Unsupported leak sanitizer requested for Apple. Ignored")
            else()
                list(APPEND icm_san_flags -fsanitize=leak)
            endif()
        endif()
    endif()
    if(icm_san_flags)
        add_compile_options(${icm_san_flags})
        add_link_options(${icm_san_flags})
    endif()
endif()
