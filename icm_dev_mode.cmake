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

set(CMAKE_LINK_DEPENDS_NO_SHARED ON)

option(SAN_THREAD "${CMAKE_PROJECT_NAME}: sanitize thread" OFF)
option(SAN_ADDR "${CMAKE_PROJECT_NAME}: sanitize address" OFF)
option(SAN_UB "${CMAKE_PROJECT_NAME}: sanitize undefined behavior" OFF)
option(SAN_LEAK "${CMAKE_PROJECT_NAME}: sanitize leaks" OFF)

set(icm_compiler_flags "")
set(icm_linker_flags "")
set(icm_compiler_and_linker_flags "")

if(MSVC)
    # /Zc:preprocessor - incompatible with Windows.h
    # /Zc:templateScope - TODO: add when msvc 17.5 is the norm
    set(icm_compiler_flags "/W4 -D_CRT_SECURE_NO_WARNINGS /Zc:__cplusplus /permissive-\
        /volatile:iso /Zc:throwingNew /utf-8 -DNOMINMAX=1\
        /w34100 /w34189 /w34701 /w34702 /w34703 /w34706 /w34714 /w34913\
        /wd4251 /wd4275"
    )
else()
    set(icm_compiler_flags "-Wall -Wextra")
endif()

if(MSVC)
    if(SAN_ADDR)
        set(icm_compiler_flags "${icm_compiler_flags} /fsanitize=address")
    endif()
    if(SAN_THREAD OR SAN_UB OR SAN_LEAK)
        message(WARNING "Unsupported sanitizers requested for msvc. Ignored")
    endif()
else()
    if(SAN_THREAD)
        set(icm_compiler_and_linker_flags "${icm_compiler_and_linker_flags} -fsanitize=thread -g")
        if(SAN_ADDR OR SAN_UB OR SAN_LEAK)
            message(WARNING "Incompatible sanitizer combination requested. Only 'SAN_THREAD' will be respected")
        endif()
    else()
        if(SAN_ADDR)
            set(icm_compiler_and_linker_flags "${icm_compiler_and_linker_flags} -fsanitize=address -pthread")
        endif()
        if(SAN_UB)
            set(icm_compiler_and_linker_flags "${icm_compiler_and_linker_flags} -fsanitize=undefined")
        endif()
        if(SAN_LEAK)
            if(APPLE)
                message(WARNING "Unsupported leak sanitizer requested for Apple. Ignored")
            else()
                set(icm_compiler_and_linker_flags "${icm_compiler_and_linker_flags} -fsanitize=leak")
            endif()
        endif()
    endif()
endif()

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${icm_compiler_flags} ${icm_compiler_and_linker_flags}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${icm_compiler_flags} ${icm_compiler_and_linker_flags}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${icm_linker_flags} ${icm_compiler_and_linker_flags}")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${icm_linker_flags} ${icm_compiler_and_linker_flags}")

# all binaries to bin
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
