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
include(dependency/cpp_get_dependency_dir)
include(dependency/cpp_get_dependency_root)

## Writes the toolchain file for a dependency
#
# Making a dependency's toolchain file requirs:
#
#  - Copying the current toolchain file
#  - Adding any additional variables
#  - Forwarding the paths of any dependencies the dependency has
#
#  :param tc_out: The path to the toolchain we are making
#  :param tc_in: The toolchain to base the new toolchain on
#  :param args:  A list of additional CMake variables to add to the new
#                toolchain
#  :param depends: A list of dependencies
function(_cpp_write_dependency_toolchain _cwdt_tc_out _cwdt_tc_in _cwdt_args
                                         _cwdt_depends)
    file(READ ${_cwdt_tc_in} _cwdt_contents)
    file(WRITE ${_cwdt_tc_out} "${_cwdt_contents}")
    foreach(_cwdt_depend_i ${_cwdt_depends})
        _cpp_get_dependency_root(_cwdt_depend_ROOT ${_cwdt_depend_i})
        _cpp_get_dependency_dir(_cwdt_depend_DIR ${_cwdt_depend_i})
        foreach(_cwdt_suffix "ROOT" "DIR")
            set(_cwdt_var ${_cwdt_depend_i}_${_cwdt_suffix})
            set(_cwdt_val _cwdt_depend_${_cwdt_suffix})
            _cpp_does_not_contain(_cwdt_is_good "NOTFOUND" "${${_cwdt_val}}")
            if(_cwdt_is_good)
                 set(_cwdt_line "${_cwdt_var}=${${_cwdt_val}}")
                _cpp_debug_print("${_cwdt_line}")
                list(APPEND _cwdt_args "${_cwdt_line}")
            endif()
        endforeach()
    endforeach()
    _cpp_change_toolchain(TOOLCHAIN ${_cwdt_tc_out} CMAKE_ARGS "${_cwdt_args}")
endfunction()
