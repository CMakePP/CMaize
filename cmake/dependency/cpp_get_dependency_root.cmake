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

## Function that determines the root of an already found dependency's install
#
# If we find a dependency we create a helper target. That helper target has a
# property INTERFACE_INCLUDE_DIRECTORIES that is either set to:
#
# - set(Name_DIR XXX) (if it was found by a config file)
# - set(Name_ROOT XXX) (if it was found by a module file)
#
# This function will parse that string and extract the XXX from it if it is the
# second case. In all other instances the return will be set to the name of the
# return appended with "-NOTFOUND"
#
# :param root: An identifier to hold the result
# :param name: The name of the dependency
#
function(_cpp_get_dependency_root _cgdr_root _cgdr_name)
    set(_cgdr_target _cpp_${_cgdr_name}_External)
    _cpp_is_not_target(_cgdr_is_not_target ${_cgdr_target})
    if(_cgdr_is_not_target)
        set(${_cgdr_root} "${_cgdr_root}-NOTFOUND" PARENT_SCOPE)
        return()
    endif()
    get_target_property(
        _cgdr_line ${_cgdr_target} INTERFACE_INCLUDE_DIRECTORIES
    )
    string(
        REGEX MATCH "${_cgdr_name}_ROOT (.*)" _cgdr_root_regex "${_cgdr_line}"
    )
    _cpp_is_not_empty(_cgdr_is_root _cgdr_root_regex)
    if(_cgdr_is_root)
        set(${_cgdr_root} ${CMAKE_MATCH_1} PARENT_SCOPE)
        return()
    endif()
    set(${_cgdr_root} "${_cgdr_root}-NOTFOUND" PARENT_SCOPE)
endfunction()
