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
# 1.01 (2024-10-25) Allow more values for icm_auto_option
# 1.00 (2024-10-11) Initial release
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
# The macro also defines two helper options:
#
# * <option>_REQUIRED which is either empty or REQUIRED.
#   Besides in `if` checks, it can be used to conditionally require a
#   package or feature
#
#   Example:
#   icm_auto_option(USE_SSL "myproj: use SSL" AUTO)
#   set(have_ssl FALSE)
#   if(USE_SSL)
#       # error if USE_SSL is set to ON, but not an eror if it's set to AUTO
#       find_package(OpenSSL ${USE_SSL_REQUIRED})
#       if(NOT OpenSSL_FOUND)
#           message(STATUS "myproj not using SSL")
#       else()
#           message(STATUS "myproj using SSL")
#           set(have_ssl TRUE)
#       endif()
#   endif()
#
# * <option>_MSG_STATUS which is either STATUS or FATAL_ERROR.
#   It can be used to conditionally print a message or error
#
#   Example:
#   icm_auto_option(BUILD_GUI_EXAMPLE "myproj: build GUI example" AUTO)
#   if(WIN32)
#       message(${BUILD_GUI_EXAMPLE_MSG_STATUS}
#               "myproj: GUI example is not supported on Windows")
#   endif()

set(icm_auto_option_valid_values AUTO ON OFF TRUE FALSE YES NO)

macro(icm_auto_option var desc default)
    set(${var} ${default} CACHE STRING ${desc})

    if(NOT ${var} IN_LIST icm_auto_option_valid_values)
        message(FATAL_ERROR "Invalid value for ${var}: ${${var}}")
    endif()

    # smaller comprehensive list for GUIs
    set_property(CACHE ${var} PROPERTY STRINGS AUTO ON OFF)

    if(NOT ${var} OR ${${var}} STREQUAL AUTO)
        # not required
        set(${var}_REQUIRED)
        set(${var}_MSG_STATUS STATUS)
    else()
        set(${var}_REQUIRED REQUIRED)
        set(${var}_MSG_STATUS FATAL_ERROR)
    endif()
endmacro()
