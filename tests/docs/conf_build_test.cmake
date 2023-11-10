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

cmake_minimum_required(VERSION 3.19) # For COMMAND_ERROR_IS_FATAL

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

#######################################:q############################
# Make a prefix for this run which won't clash with previous runs #
###################################################################

string(TIMESTAMP test_prefix)
set(test_build_dir "${CMAKE_BINARY_DIR}/${TEST_NAME}/${test_prefix}")
set(install_build_dir "${test_build_dir}-install")
message("In conf_build_test: ${CMAKE_MODULE_PATH}")
#############
# Configure #
#############

execute_process(
    COMMAND ${CMAKE_COMMAND} -H${TEST_SOURCE}
                             -B${test_build_dir}
                             -DCMAKE_INSTALL_PREFIX=${install_build_dir}
                             -DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}
                             ${args_to_forward}
    COMMAND_ERROR_IS_FATAL ANY
)

#########
# Build #
#########

execute_process(
    COMMAND ${CMAKE_COMMAND} --build ${test_build_dir}
    COMMAND_ERROR_IS_FATAL ANY
)

########
# Test #
########

execute_process(
    COMMAND ${CMAKE_COMMAND} --build ${test_build_dir} -t test
    COMMAND_ERROR_IS_FATAL ANY
)

###########
# Install #
###########

if(NOT NO_INSTALL)
    execute_process(
        COMMAND ${CMAKE_COMMAND} --build ${test_build_dir} -t install
        COMMAND_ERROR_IS_FATAL ANY
    )
endif()

if(RUN_TEST_INSTALL)
    execute_process(
        COMMAND ${CMAKE_COMMAND} -DTEST_SOURCE=${TEST_SOURCE}/test_install
                                 -DTEST_NAME=testing_install_of_${TEST_NAME}
                                 -DNO_INSTALL=TRUE
                                 -DRUN_TEST_INSTALL=FALSE
                                 -P ${CMAKE_CURRENT_LIST_FILE}
                                 -DINSTALL_LOCATION=${install_build_dir}
        COMMAND_ERROR_IS_FATAL ANY
    )
else()
    message(DEBUG "No install test specified!")
endif()
