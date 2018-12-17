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

## Function for turning the usual find module variables into a target
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
function(_cpp_handle_find_module_vars _chfmv_name)
    #Make sure target doesn't exist already
    _cpp_is_target(_chfmv_is_target ${_chfmv_name})
    if(_chfmv_is_target)
        return()
    endif()

    #Make the capitialization variations
    string(TOUPPER ${_chfmv_name} _chfmv_uc_name)
    string(TOLOWER ${_chfmv_name} _chfmv_lc_name)

    #Skim variables onto target
    add_library(${_chfmv_name} INTERFACE IMPORTED)
    foreach(_chfmv_var ${_chfmv_name} ${_chfmv_uc_name} ${_chfmv_lc_name})
        set(_chfmv_include ${_chfmv_var}_INCLUDE_DIRS)
        _cpp_is_not_empty(_chfmv_has_incs ${_chfmv_include})
        if(_chfmv_has_incs)
            target_include_directories(
                ${_chfmv_name} INTERFACE ${${_chfmv_include}}
            )
        endif()
        set(_chfmv_lib ${_chfmv_var}_LIBRARIES)
        _cpp_is_not_empty(_chfmv_has_libs ${_chfmv_lib})
        if(_chfmv_has_libs)
            target_link_libraries(${_chfmv_name} INTERFACE ${${_chfmv_lib}})
        endif()
    endforeach()
endfunction()
