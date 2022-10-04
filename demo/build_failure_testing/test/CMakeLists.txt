# Copyright (c) Borislav Stanimirov
# SPDX-License-Identifier: MIT
#

# just a sample unit test
# not related to build failure testing
add_executable(mylib-unit-test unit-test.cpp)
target_link_libraries(mylib-unit-test mylib)
add_test(NAME mylib-unit COMMAND mylib-unit-test)

# build failure tests:

include(icm_build_failure_testing)

# A bad test
# the build fails but not because of library misuse
icm_add_build_failure_test(
    NAME mylib-bf-add-bad
    TARGET mylib-bf-add-bad-test
    SOURCES bf-add-bad.cpp
    LIBRARIES mylib
    FOLDER test
)

# Add expected error in cmake with ERROR_MATCHES
icm_add_build_failure_test(
    NAME mylib-bf-add-first
    TARGET mylib-bf-add-first-test
    SOURCES bf-add-first.cpp
    LIBRARIES mylib
    ERROR_MATCHES "add: values must be integral"
    FOLDER test
)

# Test which parses a source file for an expected error message
icm_add_build_failure_test(
    NAME mylib-bf-add-second
    TARGET mylib-bf-add-second-test
    SOURCES PARSE bf-add-second.cpp
    LIBRARIES mylib
    FOLDER test
)

# Adding multiple tests with a glob
icm_glob_build_failure_tests(
    PATTERN bf-mul*
    LIBRARIES mylib
    PREFIX mylib
    FOLDER test
)
