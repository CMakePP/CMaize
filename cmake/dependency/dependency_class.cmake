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
include(object/object)

## Constructor for the Dependency class
#
# An instance of the Dependency class tracks everything we know about a
# dependency. This includes:
#
# * name         - The name of the dependency
# * version      - The version of the dependency
# * root         - The path to the root of the dependency's install directory
# * search_paths - List of include paths.
# * get_recipe   - Handle to an object of type GetRecipe
# * build_recipe - Handle to an object of type BuildRecipe
# * find_recipe  - Handle to an object of type FindRecipe
#
# The ``search_paths`` member stores a list of all paths that were in play
# when a dependency was found. Generally speaking this will be any paths
# included via ``CMAKE_PREFIX_PATH`` as well as paths stemming from computed
# hints (such as the cache).
#
#
function(_cpp_Dependency_constructor _cDc_instance)
    _cpp_Object_constructor(
        _cDc_handle Dependency
        name
        version
        root
        search_paths
        get_recipe
        build_recipe
        find_recipe
    )
    set(${_cDc_instance} ${_cDc_handle} PARENT_SCOPE)
endfunction()
