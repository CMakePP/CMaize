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

include_guard()

include(cmaize/user_api/add_executable)

#[[[
# User macro to add a set of CTest tests.
#
# .. warning::
#
#    ``cpp_add_tests()`` is depricated. ``cmaize_add_tests()`` should be
#    used to create new tests.
#
# :param _cat_test_name: Name for the test, test executable, and test command.
# :type _cat_test_name: desc
# :param INCLUDE_DIR: Directory containing files to include.
# :type INCLUDE_DIR: path, optional
# :param INCLUDE_DIRS: Directories containing files to include. If this
#                      parameter is given a value, the value of ``INCLUDE_DIR``
#                      will be ignored.
# :type INCLUDE_DIRS: List[path], optional
#]]
macro(cpp_add_tests _cat_test_name)

    set(_cat_one_value_args INCLUDE_DIR)
    set(_cat_multi_value_args INCLUDE_DIRS)
    cmake_parse_arguments(
        _cat "" "${_cat_one_value_args}" "${_cat_multi_value_args}" ${ARGN}
    )

    # Historically, only INCLUDE_DIR was used, so INCLUDE_DIRS needs to
    # be generated based on the value of INCLUDE_DIR. If INCLUDE_DIRS is
    # provided, INCLUDE_DIR is ignored.
    list(LENGTH _cat_INCLUDE_DIRS _cat_INCLUDE_DIRS_n)
    if(NOT "${_cat_INCLUDE_DIRS_n}" GREATER 0)
        set(_cat_INCLUDE_DIRS "${_cat_INCLUDE_DIR}")
    endif()

    cmaize_add_tests(
        "${_cat_test_name}"
        INCLUDE_DIRS "${_cat_INCLUDE_DIRS}"
        ${_cat_UNPARSED_ARGUMENTS}
    )

endmacro()

#[[[
# User macro to add a set of CTest tests.
#
# .. note::
#
#    For additional optional parameters related to the specific language
#    used, see the documentation for `cmaize_add_executable()`.
#
# :param _cat_test_name: Name for the test, test executable, and test command.
# :type _cat_test_name: desc
#]]
macro(cmaize_add_tests _cat_test_name)

    message(VERBOSE "Registering test target: ${_cat_test_name}")

    include(CTest)
    cmaize_add_executable("${_cat_test_name}" ${ARGN})
    add_test(NAME "${_cat_test_name}" COMMAND "${_cat_test_name}")

endmacro()
