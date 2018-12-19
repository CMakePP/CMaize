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

## Function providing the kwargs recognized by each recipe type
#
# Each of the various recipe types supports a number of kwargs. For the user's
# convenience we allow the union of those kwargs as input to
# :ref:`cpp_find_dependency-label` and :ref:`cpp_find_or_build_dependency`.
# This in turn means we need to parse the kwargs at several levels. This
# function decouples those parsing points from the list of available kwargs.
#
# .. note::
#
#     If two recipes take the same kwarg they must use it for identical
#     purposes.
#
# :param toggles: An identifier to store the toggles the recipe recognizes.
# :param options: An identifier to store the options the recipe recognizes.
# :param lists: An identifer to store the lists the recipe recognizes.
# :param type: The recipe type. Must be "BUILD", "GET", or "FIND".
#
function(_cpp_recipe_kwargs _crk_toggles _crk_options _crk_lists _crk_type)
    if("${_crk_type}" STREQUAL "BUILD")
        _cpp_build_recipe_kwargs(_crk_toggles _crk_options _crk_lists)
    elseif("${_crk_type}" STREQUAL "FIND")
        _cpp_find_recipe_kwargs(_crk_toggles _crk_options _crk_lists)
    elseif("${_crk_type}" STREQUAL "GET")
        _cpp_get_recipe_kwargs(_crk_toggles _crk_options _crk_lists)
    else()
        _cpp_error("Do not recognize recipe type: ${_crk_type}")
    endif()
    set(${_crk_toggles} "${${_crk_toggles}}" PARENT_SCOPE)
    set(${_crk_options} "${${_crk_options}}" PARENT_SCOPE)
    set(${_crk_lists} "${${_crk_lists}}" PARENT_SCOPE)
endfunction()
