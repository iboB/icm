# icm_dev_mode
#
# MIT License:
# Copyright(c) 2020 Borislav Stanimirov
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
# * No extensions
# * Stanard required
# * More warnigns for gcc and clang
# * Disable some overly aggressive warnings for msvc
# * options SAN_THREAD and SAN_ADDR (only one or zero of them must be ON)
#   to enable thread and address sanitizers
# * set runtime out directory to bin (useful for msvc so dlls are next to exes)

if (NOT CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
    return()
endif()

if (ICM_NO_DEVMODE)
    return()
endif()

set(ICM_DEV_MODE ON)

if (NOT ICM_DEV_CXX_STANDARD)
    set(ICM_DEV_CXX_STANDARD 17)
endif()

set(CMAKE_CXX_STANDARD ${ICM_DEV_CXX_STANDARD})
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

option(SAN_THREAD "${CMAKE_PROJECT_NAME}: sanitize thread" OFF)
option(SAN_ADDR "${CMAKE_PROJECT_NAME}: sanitize address" OFF)

set(icm_san_flags "")
if(MSVC)
    set(icm_warning_flags "-D_CRT_SECURE_NO_WARNINGS /wd4251 /wd4275 /Zc:__cplusplus")
else()
    set(icm_warning_flags "-Wall -Wextra -Wno-type-limits")
endif()

if(SAN_THREAD)
    if(NOT MSVC)
        set(icm_san_flags "-fsanitize=thread -g")
    endif()
elseif(SAN_ADDR)
    if(MSVC)
        # TODO: test and then enable
        # set(icm_san_flags "-fsanitize=address")
    elseif(APPLE)
        # apple clang doesn't support the leak sanitizer
        set(icm_san_flags "-fsanitize=address,undefined -pthread -g")
    else()
        set(icm_san_flags "-fsanitize=address,undefined,leak -pthread -g")
    endif()
endif()

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${icm_warning_flags} ${icm_san_flags}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${icm_warning_flags} ${icm_san_flags}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${icm_san_flags}")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${icm_san_flags}")

# all binaries to bin
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
