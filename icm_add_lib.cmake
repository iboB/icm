# icm_add_lib
#
# SPDX-License-Identifier: MIT
# MIT License:
# Copyright (c) 2020-2022 Borislav Stanimirov
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
#   1.03 (2023-11-24) Use BUILD_SHARED_LIBS as opposed to ICM_STATIC_LIBS
#   1.02 (2023-10-04) Add -fvisibility-inlines-hidden for *nix builds
#   1.01 (2022-10-05) Macros to functions
#   1.00 (2020-12-25) Initial standalone release
#
include_guard(GLOBAL)

# icm_add_shared_lib
#
# icm_add_shared_lib(mylib MYLIB mylib_a.cpp mylib_b.cpp)
# Adds a shared library, forces visibility hidden, and adds definitons
# Args:
#   * target - name of the target (the lib we're adding)
#   * cname  - a name to be used when for the definitons added must be a valid
#              C/C++ symbol name
#   * ...    - sources
# Definitions added to target when cname is "MYLIB":
#   * BUILDING_MYLIB=1
#   * MYLIB_SHARED=1
# Thus for the library you can use a main include file like this:
#
# // mylib_api.h
# #if MYLIB_SHARED
# #   if BUILDING_MYLIB
# #       define MYLIB_API SYMBOL_EXPORT
# #   else
# #       define MYLIB_API SYMBOL_IMPORT
# #   endif
# #else
# #   define MYLIB_API
# #endif
function(icm_add_shared_lib target cname)
    add_library(${target} SHARED ${ARGN})
    if(NOT WIN32)
        target_compile_options(${target} PRIVATE
            -fvisibility=hidden
            -fvisibility-inlines-hidden
        )
    endif()

    target_compile_definitions(${target}
        PRIVATE -DBUILDING_${cname}=1
        PUBLIC -D${cname}_SHARED=1
    )
endfunction()

# icm_add_lib
#
# icm_add_lib(mylib MYLIB mylib_a.cpp mylib_b.cpp)
# Adds a shared library by calling `icm_add_shared_lib` unless any of the
# following is true:
# * BUILD_SHARED_LIBS defined and is falsy (the opposide default of add_library)
# * ${cname}_STATIC is true
# ... in which case it adds a static library
function(icm_add_lib target cname)
    if(DEFINED BUILD_SHARED_LIBS AND NOT BUILD_SHARED_LIBS)
        set(bslStatic TRUE)
    endif()
    if(bslStatic OR ${cname}_STATIC)
        add_library(${target} STATIC ${ARGN})
    else()
        icm_add_shared_lib(${target} ${cname} ${ARGN})
    endif()
endfunction()
