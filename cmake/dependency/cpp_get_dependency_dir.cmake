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

## Determines the path of an already found dependency's config files
#
# If we find a dependency we create a helper target. That helper target has a
# property INTERFACE_INCLUDE_DIRECTORIES that is either set to:
#
# - set(Name_DIR XXX) (if it was found by a config file)
# - set(Name_ROOT XXX) (if it was found by a module file)
#
# This function will parse that string and extract the XXX from it if it is the
# first case. In all other instances the return will be set to the name of the
# return appended with "-NOTFOUND"
#
# :param dir: An identifier to hold the result
# :param name: The name of the dependency
#
function(_cpp_get_dependency_dir _cgdd_dir _cgdd_name)
    set(_cgdd_target _cpp_${_cgdd_name}_External)
    _cpp_is_not_target(_cgdd_is_not_target ${_cgdd_target})
    if(_cgdd_is_not_target)
        set(${_cgdd_dir} "${_cgdd_dir}-NOTFOUND" PARENT_SCOPE)
        return()
    endif()
    get_target_property(
        _cgdd_line ${_cgdd_target} INTERFACE_INCLUDE_DIRECTORIES
    )
    string(
        REGEX MATCH "${_cgdd_name}_DIR (.*)" _cgdd_dir_regex "${_cgdd_line}"
    )
    _cpp_is_not_empty(_cgdd_is_dir _cgdd_dir_regex)
    if(_cgdd_is_dir)
        set(${_cgdd_dir} ${CMAKE_MATCH_1} PARENT_SCOPE)
        return()
    endif()
    set(${_cgdd_dir} "${_cgdd_dir}-NOTFOUND" PARENT_SCOPE)
endfunction()
