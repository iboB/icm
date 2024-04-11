# icm_check_charconv_fp_to_chars
#
# SPDX-License-Identifier: MIT
# MIT License:
# Copyright (c) 2024 Borislav Stanimirov
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
# 1.0.0 (2024-04-11) Initial release
#
#           DOCUMENTATION
#
# Check whether charconv has floating-point to_chars. Sadly in in 2024 this is
# still not implemented in many popular and supported compilers. :(
#
# To use simply include this file. After that haveCharconvFpToChars will be set
# to a truthy or a falsy value.
#
#           EXAMPLE USAGE
#
# include(icm_check_charconv_fp_to_chars)
# if(NOT haveCharconvFpToChars)
#     message("no charconv floating point support detected. Using mscharconv")
#     # using CPM to fetch mscharconv
#     CPMAddPackage(gh:iboB/mscharconv@1.2.3)
#     target_link_libraries(mytarget PUBLIC msstl::charconv)
#     target_compile_definitions(mytarget PUBLIC -DUSE_MSCHARCONV=1)
# else()
#     message("detected charconv floating point support")
# endif()
#
#           NOTES
#
# This file is bundled with icm_check_charconv_fp_to_chars.cpp and expects it
# to be in its directory.
include_guard(GLOBAL)

try_compile(haveCharconvFpToChars ${CMAKE_CURRENT_BINARY_DIR}/icmHaveCharconvFpToChars
    ${CMAKE_CURRENT_LIST_DIR}/icm_check_charconv_fp_to_chars.cpp
    CXX_STANDARD 17
)
