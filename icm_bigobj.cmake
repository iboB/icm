# icm_bigobj
#
# SPDX-License-Identifier: MIT
# MIT License:
# Copyright (c) 2021 Borislav Stanimirov
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
#   1.00 (2021-02-07) Initial standalone release
#
include_guard(GLOBAL)

# icm_bigobj
#
# icm_bigobj(source_file.cpp)
# Marks a source file as a "big object"
# For MSVC adds the /bigobj flag
# On other compilers it does nothing
function(icm_bigobj srcFile)
    if(MSVC)
        get_source_file_property(icm_bigobjFileProps ${srcFile} COMPILE_FLAGS)
        if(${icm_bigobjFileProps} STREQUAL "NOTFOUND")
            set(icm_bigobjFileProps)
        endif()
        set_source_files_properties(${srcFile} PROPERTIES COMPILE_FLAGS "${icm_bigobjFileProps} /bigobj")
    endif()
endfunction(icm_bigobj)
