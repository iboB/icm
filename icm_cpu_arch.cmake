# icm_cpu_arch
#
# SPDX-License-Identifier: MIT
# MIT License:
# Copyright (c) 2025 Borislav Stanimirov
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
#   1.00 (2025-09-27) Initial release
#
include_guard(GLOBAL)

# store current dir to find icm_build_failure_parse_and_run
set(ICM_CPU_ARCH_LIST_DIR "${CMAKE_CURRENT_LIST_DIR}")

function(icm_get_native_arch_flag var)
    if(CMAKE_CROSSCOMPILING)
        message(WARNING "icm_get_native_arch_flag: native arch is not intended for cross-compiling")
        set(${var} "" PARENT_SCOPE)
    elseif(NOT MSVC)
        set(${var} "-march=native" PARENT_SCOPE)
    elseif(DEFINED ICM_CPU_ARCH_MSVC_NATIVE_FLAG)
        set(${var} "${ICM_CPU_ARCH_MSVC_NATIVE_FLAG}" PARENT_SCOPE)
    else()
        # detect and cache
        try_run(
            icm_cpu_arch_get_msvc_native_flags_run_result
            icm_cpu_arch_get_msvc_native_flags_compile_result
            ${CMAKE_BINARY_DIR}/icmGetNativeArchFlag
            ${ICM_CPU_ARCH_LIST_DIR}/icm_cpu_arch_get_msvc_native_flags.cpp
            RUN_OUTPUT_VARIABLE output
        )
        set(ICM_CPU_ARCH_MSVC_NATIVE_FLAG "/arch:${output}" CACHE STRING "MSVC native arch flag detected")
        set(${var} "/arch:${output}" PARENT_SCOPE)
    endif()
endfunction()
