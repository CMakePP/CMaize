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
include(dependency/read_helper_targets)
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
    #Add the dependencies paths to the hints so they can be found too
    _cpp_read_helper_targets(_cwdt_fr "${_cwdt_depends}")
    set(_cwdt_hints ${CMAKE_PREFIX_PATH})
    foreach(_cwdt_depend_i ${_cwdt_fr})
        _cpp_Object_get_value(${_cwdt_depend_i} _cwdt_path paths)
        list(APPEND _cwdt_hints "${_cwdt_path}")
    endforeach()
    string(REPLACE ";" "\\\\\\;" _cwdt_hints "${_cwdt_hints}" )
    list(APPEND _cwdt_args "CMAKE_PREFIX_PATH=\"${_cwdt_hints}\"")
    _cpp_change_toolchain(TOOLCHAIN ${_cwdt_tc_out} CMAKE_ARGS "${_cwdt_args}")
endfunction()
