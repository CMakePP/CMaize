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

## Function that modifies the real toolchain into one for testing
#
# While running tests we need a toolchain that we can freely modify without
# fears of clobbering the real toolchain. This testing toolchain also needs to
# have its value of the CPP cache updated to the testing version. Those are this
# function's main tasks. After calling this function the value of
# ``CMAKE_TOOLCHAIN_FILE`` will be updated to point to the testing toolchain.
#
# :param prefix: The effective binary directory for this test.
#
# :CMake Varaibles:
#
#     * *CMAKE_TOOLCHAIN_FILE* - Used to get the current toolchain. The value
#       of this variable will be set to ``${test_prefix}/toolchain.cmake`` after
#       this call.
function(_cpp_make_test_toolchain _cmtt_prefix)
    file(READ ${CMAKE_TOOLCHAIN_FILE} _cmtt_file)
    string(REGEX REPLACE "\n" ";" _cmtt_file "${_cmtt_file}")
    set(_cmtt_new_file)
    foreach(_cmtt_line ${_cmtt_file})
        string(FIND "${_cmtt_line}" "set(CPP_INSTALL_CACHE"  _cmtt_is_cache)
        if("${_cmtt_is_cache}" STREQUAL "-1")
            list(APPEND _cmtt_new_file "${_cmtt_line}")
        else()
            list(
                    APPEND
                    _cmtt_new_file
                    "set(CPP_INSTALL_CACHE \"${_cmtt_prefix}/cpp_cache\")"
            )
        endif()
    endforeach()
    file(MAKE_DIRECTORY ${_cmtt_prefix}/cpp_cache)
    string(REGEX REPLACE ";" "\n" _cmtt_new_file "${_cmtt_new_file}")
    file(WRITE "${_cmtt_prefix}/toolchain.cmake" "${_cmtt_new_file}")
    set(CMAKE_TOOLCHAIN_FILE "${_cmtt_prefix}/toolchain.cmake" PARENT_SCOPE)
endfunction()
