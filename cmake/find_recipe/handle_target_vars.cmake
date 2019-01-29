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
include(string/cpp_string_cases)

## Function for turning the usual ``find_package`` variables into a target
#
# In the olden days of CMake one found dependencies by using find modules. For
# the most part these find modules do not create targets. Modern CMake dictates
# that each dependency should create an imported interface target that can be
# linked against. This function bridges the gap by searching for the legacy
# CMake variables and creating a target with then name of the package.
#
# This function recognizes the following legacy variables:
#
# * ``<XXX>_INCLUDE_DIRS`` for the directories containing header files
# * ``<XXX>_LIBRARIES`` for the libraries to link against
#
# In all cases ``XXX`` is the name of the dependency assuming it adheres to one
# of the following capitalization schemes:
#
# * The capitalization used as input to this function (*i.e.*, the value of
#   ``name``.
# * The name of the package in all lowercase letters.
# * The name of the package in all uppercase letters.
#
# :param name: The name of the package you were looking for. This will also be
#     used as the name of the resulting target.
#
function(_cpp_handle_target_vars _chtv_name)
    #Make sure target doesn't exist already

    _cpp_is_target(_chtv_is_target ${_chtv_name})
    if(_chtv_is_target)
        return()
    endif()

    _cpp_string_cases(_chtv_cases "${_chtv_name}")

    #Skim variables onto target
    add_library(${_chtv_name} INTERFACE IMPORTED)
    foreach(_chtv_var ${_chtv_cases})

        set(_chtv_include ${_chtv_var}_INCLUDE_DIRS)
        _cpp_is_not_empty(_chtv_has_incs ${_chtv_include})
        if(_chtv_has_incs)
            target_include_directories(
                ${_chtv_name} INTERFACE ${${_chtv_include}}
            )
        endif()

        set(_chtv_lib ${_chtv_var}_LIBRARIES)
        _cpp_is_not_empty(_chtv_has_libs ${_chtv_lib})
        if(_chtv_has_libs)
            target_link_libraries(${_chtv_name} INTERFACE ${${_chtv_lib}})
        endif()
    endforeach()

endfunction()
