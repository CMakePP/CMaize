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
include(recipes/cpp_generate_get_recipe)
include(cache/cache_get_recipe)
include(recipes/cpp_generate_build_recipe)
include(cache/cache_build_recipe)
include(recipes/cpp_generate_find_recipe)
include(cache/cache_find_recipe)

function(_cpp_cache_write_get_recipe _ccwgr_cache _ccwgr_name _ccwgr_url
                                     _ccwgr_private _ccwgr_branch _ccwgr_src)
    _cpp_generate_get_recipe(
        _ccwgr_get_contents
        "${_ccwgr_url}"
        "${_ccwgr_private}"
        "${_ccwgr_branch}"
        "${_ccwgr_src}"
    )
    _cpp_cache_add_get_recipe(
        ${_ccwgr_cache} ${_ccwgr_name} "${_ccwgr_get_contents}"
    )
endfunction()

function(_cpp_cache_write_find_recipe _ccwfr_cache _ccwfr_name)
    _cpp_find_recipe_dispatch(
        _ccwfr_find_conts ${_ccwfr_cache} ${_ccwfr_name} ${ARGN})
    _cpp_cache_add_find_recipe(
        ${_ccwfr_cache} ${_ccwfr_name} "${_ccwfr_find_conts}"
    )
endfunction()

function(_cpp_cache_write_build_recipe _ccwbr_cache _ccwbr_name _ccwbr_args
                                       _ccwbr_module)
    _cpp_generate_build_recipe(
      _ccwbr_build_conts "${_ccwbr_args}" "${_ccwbr_module}"
    )
    _cpp_cache_add_build_recipe(
        ${_ccwbr_cache} ${_ccwbr_name} "${_ccwbr_build_conts}"
    )
endfunction()

function(_cpp_cache_add_dependency _ccad_cache _ccad_name)
    _cpp_cache_write_get_recipe(${_ccad_cache} ${_ccad_name} ${ARGN})
    _cpp_cache_write_find_recipe(${_ccad_cache} ${_ccad_name} ${ARGN})
    _cpp_cache_write_build_recipe(${_ccad_cache} ${_ccad_name} ${ARGN})
endfunction()
