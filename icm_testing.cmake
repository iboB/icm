# icm_testing
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

# icm_add_test
#
# Create an executable target and add it as a test
# Args:
#   * NAME name       - name of the test (visible when ctest is run)
#   * TARGET target   - name of the executable
#   * SOURCES sources - sources for the executable
#   * LIBRARIES libs  - libraries to link with
#   * FOLDER folder   - MSVC solution folder for the target
macro(icm_add_test)
    cmake_parse_arguments(ARG "" "NAME;TARGET;FOLDER" "SOURCES;LIBRARIES" ${ARGN})
    add_executable(${ARG_TARGET} ${ARG_SOURCES})
    if(NOT "${ARG_LIBRARIES}" STREQUAL "")
        target_link_libraries(${ARG_TARGET} PRIVATE ${ARG_LIBRARIES})
    endif()
    if(NOT "${ARG_FOLDER}" STREQUAL "")
        set_target_properties(${ARG_TARGET} PROPERTIES FOLDER ${FOLDER})
    endif()
    add_test(NAME ${ARG_NAME} COMMAND ${ARG_TARGET})
endmacro()

# icm_add_doctest_lib_test
#
# Creates an executable target, link with doctest and a given lib, add
# as a test and add to solution folder "test".
#
# Args:
#   * test - name of the test (visible when ctest is run)
#   * lib  - name of the library to test
# Notes:
# The executable for `icm_add_doctest_lib_test(core mylib test_core.cpp)` is:
# test-mylib-core
macro(icm_add_doctest_lib_test test lib)
    icm_add_test(
        NAME ${test}
        TARGET test-${lib}-${test}
        LIBRARIES doctest-main ${lib}
        SOURCES ${ARGN}
        FOLDER test
    )
endmacro()
