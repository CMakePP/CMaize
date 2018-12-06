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
include(recipes/cpp_get_recipe_dispatch)
include(cache/cache_get_recipe)
include(recipes/cpp_find_recipe_dispatch)
include(cache/cache_find_recipe)
include(recipes/cpp_build_recipe_dispatch)
include(cache/cache_build_recipe)

function(_cpp_cache_add_dependency _ccad_cache _ccad_name)
    #Note it's possible for version to be empty
    _cpp_get_recipe_dispatch(_ccad_get_contents ${ARGN})

    _cpp_cache_add_get_recipe(
        ${_ccad_cache} ${_ccad_name} "${_ccad_get_contents}"
    )

    _cpp_find_recipe_dispatch(
        _ccad_find_contents ${_ccad_cache} ${_ccad_name} ${ARGN}
    )

    _cpp_cache_add_find_recipe(
            ${_ccad_cache} ${_ccad_name} "${_ccad_find_contents}"
    )

    _cpp_build_recipe_dispatch(_ccad_build_conts ${ARGN})

    _cpp_cache_add_build_recipe(
            ${_ccad_cache} ${_ccad_name} "${_ccad_build_conts}"
    )
endfunction()
