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

################################################################################
#            Functions for delcaring unit tests in various languages           #
################################################################################
include(cpp_print) #For debug printing

function(cpp_cmake_unit_test _ccut_name)
    get_filename_component(_ccut_test_file test_${_ccut_name}.cmake REALPATH)
    add_test(
            NAME ${_ccut_name}
            COMMAND ${CMAKE_COMMAND}
            "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
            -P ${_ccut_test_file}
    )
    _cpp_debug_print("Added CMake Unit Test:")
    _cpp_debug_print("  Name: ${_ccut_name}")
    _cpp_debug_print("  File: ${_ccut_test_file}")
endfunction()
