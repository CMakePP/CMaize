# Copyright 2023 CMakePP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#[[[ @module
# Script for configuring, building, testing, and installing a project.
#
# CMaize is ultimately a build system. There are tests which can only be done
# when CMaize is run as a build system, i.e. we need to test CMaize
# functionality during CMake's configuration, build, test, and install phases.
# Think of this script as a bash script wrapping the process of running CMake's
# configuration, build, test, and install commands, only that instead of being
# written in bash it is written in CMake (for cross-platform-ness). Ultimately
# this script is meant to be invoked via:
#
# .. code-block:: bash
#
#    cmake -DTEST_SOURCE=<directory_continaing_the_build_system_to_test> \
#          -DTEST_NAME=<descriptive_name_of_build_system> \
#          -DNO_INSTALL=<false_if_we_should_install_the_build_system> \
#          -DRUN_TEST_INSTALL=<true_if_the_install_should_be_tested_too> \
#          -P <path_to_this_script> \
#          <arguments_to_pass_to_this_script>
#
#
# .. note::
#    In the snippet above, it is important to maintain the partitioning between
#    the arguments which come before the ``-P`` argument, and those which come
#    after.
#]]


# Starting with 3.19 we have COMMAND_ERROR_IS_FATAL, which is a much nicer
# solution than manually checking the variable
if("${CMAKE_VERSION}" VERSION_LESS 3.19)
    set(error_variable "RESULT_VARIABLE;_cbt_result")
    function(check_error)
        if(NOT "${_cbt_result}" STREQUAL "0")
            message(FATAL_ERROR "Command failed with error: ${_cbt_result}")
        endif()
    endfunction()
else()
    set(error_variable "COMMAND_ERROR_IS_FATAL;ANY")
    function(check_error)
    endfunction()
endif()

####################################################################
# Grab the arguments passed to the script and put them into a list #
####################################################################

set(args_to_forward "") # The list we're trying to make

# The arguments are numbered such that:
# 0. is the CMake command,
# 1. is -DTEST_SOURCE=...,
# 2. is -DTEST_NAME=...,
# 3. is -DNO_INSTALL=...
# 4. is -DRUN_TEST_INSTALL=...,
# 5. is -P
# 6. is the script name,
# 7. is the first argument we actually care about!!!!
#
# Note this needs changed if we ever call the script with a different syntax
set(first_arg 7)

# CMake ranges are inclusive and 0 based, so the stopping point is the length
# minus 1
math(EXPR last_arg "${CMAKE_ARGC} - 1")

# If there were no additional arguments, last_arg is less than first_arg and
# the loop will actually count down! If we specify the step size as 1, we get
# an error. So if ${CMAKE_ARGC} == ${first_arg} we just need to skip the loop

if(NOT ${first_arg} STREQUAL ${CMAKE_ARGC})
    foreach(i RANGE ${first_arg} ${last_arg} 1)
        list(APPEND args_to_forward "${CMAKE_ARGV${i}}")
    endforeach()
endif()

message(DEBUG "conf_build_test called with: ${args_to_forward}")

###################################################################
# Make a prefix for this run which won't clash with previous runs #
###################################################################

string(TIMESTAMP test_prefix)
set(test_build_dir "${CMAKE_BINARY_DIR}/${TEST_NAME}/${test_prefix}")
set(install_build_dir "${test_build_dir}-install")

#############
# Configure #
#############

execute_process(
    COMMAND ${CMAKE_COMMAND} -H${TEST_SOURCE}
                             -B${test_build_dir}
                             -DCMAKE_INSTALL_PREFIX=${install_build_dir}
                             -DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
                             ${args_to_forward}
    ${error_variable}
)
check_error()

#########
# Build #
#########

execute_process(
    COMMAND ${CMAKE_COMMAND} --build ${test_build_dir}
    ${error_variable}
)
check_error()

########
# Test #
########

execute_process(
    COMMAND ${CMAKE_COMMAND} --build ${test_build_dir} --target test
    ${error_variable}
)
check_error()

###########
# Install #
###########

if(NOT NO_INSTALL)
    execute_process(
        COMMAND ${CMAKE_COMMAND} --build ${test_build_dir} --target install
        ${error_variable}
    )
    check_error()
endif()

if(RUN_TEST_INSTALL)
    execute_process(
        COMMAND ${CMAKE_COMMAND} -DTEST_SOURCE=${TEST_SOURCE}/package_tests
                                 -DTEST_NAME=testing_install_of_${TEST_NAME}
                                 -DNO_INSTALL=TRUE
                                 -DRUN_TEST_INSTALL=FALSE
                                 -P ${CMAKE_CURRENT_LIST_FILE}
                                 -DINSTALL_LOCATION=${install_build_dir}
        ${error_variable}
    )
    check_error()
else()
    message(DEBUG "No install test specified!")
endif()
