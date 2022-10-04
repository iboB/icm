# icm_target_platform
#
# SPDX-License-Identifier: MIT
# MIT License:
# Copyright (c) 2021-2022 Borislav Stanimirov
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
#   1.01 (2022-10-04) All vars prefixed with TARGET_
#   1.00 (2021-01-12) Initial standalone release
#
#           DOCUMENTATION
#
# A target platform module. Include this file to get info about the target
# platform. Besides concrete platforms, common ones are also available:
# For example APPLE, ANDROID, and LINUX are all UNIX
include_guard(GLOBAL)

if(EMSCRIPTEN)
    message("-- ICM detected target platform: Emscripten")
    set(TARGET_PLATFORM_EMSCRIPTEN 1)
    set(TARGET_PLATFORM_BROWSER 1)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Android")
    message("-- ICM detected target platform: Android")
    set(TARGET_PLATFORM_ANDROID 1)
    set(TARGET_PLATFORM_UNIX 1)
    set(TARGET_PLATFORM_MOBILE 1)
elseif(APPLE)
    set(TARGET_PLATFORM_APPLE 1)
    set(TARGET_PLATFORM_UNIX 1)
    if(CMAKE_SYSTEM_NAME STREQUAL "iOS")
        message("-- ICM detected target platform: iOS")
        set(TARGET_PLATFORM_IOS 1)
        set(TARGET_PLATFORM_MOBILE 1)
    elseif(CMAKE_SYSTEM_NAME STREQUAL "tvOS")
        message("-- ICM detected target platform: tvOS")
        set(TARGET_PLATFORM_TVOS 1)
    elseif(CMAKE_SYSTEM_NAME STREQUAL "watchOS")
        message("-- ICM detected target platform: watchOS")
        set(TARGET_PLATFORM_WATCHOS 1)
    else()
        message("-- ICM detected target platform: macOS")
        set(TARGET_PLATFORM_MACOS 1)
        set(TARGET_PLATFORM_DESKTOP 1)
    endif()
elseif(WIN32)
    message("-- ICM detected target platform: Windows")
    set(TARGET_PLATFORM_WINDOWS 1)
    set(TARGET_PLATFORM_DESKTOP 1)
elseif(UNIX)
    message("-- ICM detected target platform: Linux")
    set(TARGET_PLATFORM_LINUX 1)
    set(TARGET_PLATFORM_UNIX 1)
    set(TARGET_PLATFORM_DESKTOP 1)
else()
    message(FATAL_ERROR "ICM Error: Cannot infer target platform")
endif()
