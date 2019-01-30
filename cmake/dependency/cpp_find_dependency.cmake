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
include(find_recipe/find_recipe)
include(dependency/helper_target_made)
include(dependency/set_helper_target)

## Function for finding a dependency.
#
# This function is the public API for users who want CPP to find a dependency
# that the end-user is responsible for building (*i.e.*, this function is the
# public API for finding a dependency that CPP can not build). This function is
# also used internally in :ref:`cpp_find_or_build_dependency` to handle the
# "finding" part.
#
# :kwargs:
#
#     * *NAME* (``option``) - The name of the dependency we are looking for.
#     * *VERSION* (``option``) - The version of the dependency we are looking
#       for.
#     * *COMPONENTS* (``list``) - A list of components that the dependency must
#       provide.
#     * *FIND_MODULE* (``option``) - The path to a user provided find module.
#     * *RESULT* (``option``) - An identifier in which to store whether or not
#       the dependency was found. Result is thrown away by default.
#     * *OPTIONAL* (``toggle``) - If present, failing to find the dependency is
#       **NOT** an error.
#
function(cpp_find_dependency)
    cpp_parse_arguments(
        _cfd "${ARGN}"
        TOGGLES OPTIONAL
        OPTIONS NAME VERSION FIND_MODULE RESULT PATHS COMPONENTS
        MUST_SET NAME
    )
    cpp_option(_cfd_RESULT CPP_DEV_NULL)
    _cpp_set_return(${_cfd_RESULT} TRUE) #Will change if not the case


    _cpp_helper_target_made(_cfd_been_found ${_cfd_NAME})

    if(_cfd_been_found)
        return()
    endif()

    _cpp_FindRecipe_factory(_cfd_find_recipe ${ARGN})
    _cpp_FindRecipe_find_dependency(${_cfd_find_recipe} "${_cfd_PATHS}")

    _cpp_Object_get_value(${_cfd_find_recipe} _cfd_found found)
    if("${_cfd_found}")
        _cpp_set_helper_target(${_cfd_NAME} ${_cfd_find_recipe})
        return()
    elseif("${_cfd_OPTIONAL}")
        _cpp_set_return(${_cfd_RESULT} FALSE)
        return()
    endif()

    _cpp_error(
        "Could not find ${_cfd_NAME}. Make sure ${_cfd_NAME}'s install path is "
        "either included in CMAKE_PREFIX_PATH or the value of "
        "${_cfd_NAME}_ROOT. Current CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}."
    )
endfunction()
