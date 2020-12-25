# icm_add_lib
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
macro(icm_add_shared_lib target cname)
    add_library(${target} SHARED ${ARGN})
    if(NOT WIN32)
        target_compile_options(${target} PRIVATE -fvisibility=hidden)
    endif()

    target_compile_definitions(${target}
        PRIVATE -DBUILDING_${cname}=1
        PUBLIC -D${cname}_SHARED=1
    )
endmacro()

# icm_add_lib
#
# icm_add_lib(mylib MYLIB mylib_a.cpp mylib_b.cpp)
# Adds a shared library by calling `icm_add_shared_lib` unless:
# ICM_STATIC_LIBS is true
# ... or ...
# ${cname}_STATIC is true
# ... in which case it adds a static library
macro(icm_add_lib target cname)
    if(ICM_STATIC_LIBS OR ${cname}_STATIC)
        add_library(${target} STATIC ${ARGN})
    else()
        icm_add_shared_lib(${target} ${cname} ${ARGN})
    endif()
endmacro()
