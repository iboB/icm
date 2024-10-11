# icm_option - macros for defining options
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
# 1.0.0 (2024-10-11) Initial release
#

# icm_auto_option
#
# Adds a cache option with possible values AUTO, ON, OFF
# Args:
#   * var     - the name of the variable to be created
#   * desc    - description of the option
#   * default - default value of the option (AUTO, ON, OFF)
#
# AUTO should be interpreted as letting the script or build system decide.
# The macro also defines the var <option>_REQUIRED which is either empty or
# REQUIRED. Besides in `if` checks, it can be used to conditionally require a
# package or feature
#
# Example:
# icm_auto_option(USE_SSL "myproj: use SSL" AUTO)
# set(have_ssl FALSE)
# if(USE_SSL)
#     # error if USE_SSL is set to ON, but not an eror if it's set to AUTO
#     find_package(OpenSSL ${USE_SSL_REQUIRED})
#     if(NOT OpenSSL_FOUND)
#         message(STATUS "myproj not using SSL")
#     else()
#         message(STATUS "myproj using SSL")
#         set(have_ssl TRUE)
#     endif()
# endif()
#
macro(icm_auto_option var desc default)
    set(${var} ${default} CACHE STRING ${desc})
    set_property(CACHE ${var} PROPERTY STRINGS AUTO ON OFF)
    if(${${var}} STREQUAL AUTO)
        set(${var}_REQUIRED)
    elseif(${${var}} STREQUAL ON)
        set(${var}_REQUIRED REQUIRED)
    elseif(${${var}} STREQUAL OFF)
        set(${var}_REQUIRED)
    else()
        message(FATAL_ERROR "Invalid value for ${var}: ${${var}}")
    endif()
endmacro()
