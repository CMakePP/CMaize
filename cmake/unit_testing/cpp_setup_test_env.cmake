################################################################################
#                        Copyright 2018 Ryan M. Richard                        #
#       Licensed under the Apache License, Version 2.0 (the "License");        #
#       you may not use this file except in compliance with the License.       #
#                   You may obtain a copy of the License at                    #
#                                                                              #
#                  http://www.apache.org/licenses/LICENSE-2.0                  #
#                                                                              #
#     Unless required by applicable law or agreed to in writing, software      #
#      distributed under the License is distributed on an "AS IS" BASIS,       #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
#     See the License for the specific language governing permissions and      #
#                        limitations under the License.                        #
################################################################################

include_guard()
include(unit_testing/cpp_make_test_toolchain)

## Creates a clean environment to run tests in
#
# CMake leaves a lot of environmental artificats after a run. This function
# creates a clean environment for our test so that these artificats do not
# interfere with other tests or the main CPP source code. This entails the
# following:
#
# * Creating a new directory for all test artifacts
#
#     * This directory will be in the main build directory at
#       ``${CMAKE_BINARY_DIR}/tests/<name>/<random>`` where ``<name>`` is the
#       name provided to this function  and ``<random>`` is a randomly generated
#       string.
#     * For your convenience this directory will be assigned to the variable
#       ``test_prefix``.
#     * The path to this directory is also printed so that it appears in the log
#
# * A test-specific cache is created at ``${test_prefix}/cpp_cache``
# * The build directory is set to ``${test_prefix}``
# * A copy of the toolchain is created at ``${test_prefix}/toolchain.cmake``
#
#   * The copy has been updated to reflect the aforementioned changes
#
# :param name: The name of the test case.
#
# :CMake Variables:
#
#     * *CMAKE_CURRENT_SOURCE_DIR* - Used to get the staged location of the
#       test.
#     * *CMAKE_TOOLCHAIN_FILE* - Used by :ref:`cpp_make_test_toolchain-label`.
#     * *CPP_INSTALL_CACHE* - Will be set to ``${test_prefix}/cpp_cache`` after
#       this call.
macro(_cpp_setup_test_env _cste_name)
    #Make the root directory
    set(test_prefix ${CMAKE_CURRENT_SOURCE_DIR}/${_cste_name})
    string(RANDOM _cste_random_prefix)
    set(test_prefix ${test_prefix}/${_cste_random_prefix})
    file(MAKE_DIRECTORY ${test_prefix})

    message(
        "Tests from this run of ${_cste_name} are located in ${test_prefix}"
    )

    #Make sure we don't contaminate the real cache or build directory
    _cpp_make_test_toolchain(${test_prefix})
    set(CMAKE_BINARY_DIR ${test_prefix})
    include(${CMAKE_TOOLCHAIN_FILE})
endmacro()
