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

## Wrapper function for generating a get-recipe and adding it to the cache.
#
# :param cache: The CPP cache to add the recipe to.
# :param name: The name of the dependency the recipe is for.
# :param url: The URL to download the dependency from. Set to empty string if
#     using a local directory.
# :param private: Whether or not the dependency is hosted in a private GitHub
#     repository. Ignored if dependency is not on GitHub.
# :param branch: The branch of the source code to use if the source code is
#     managed by git. Ignored if dependency does not use git for version
#     control.
# :param src: The path to the dependency's source code. Set to empty string if
#     the dependency will be downloaded.
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

## Wrapper function for generating a find-recipe and adding it to the cache.
#
# :param cache: The CPP cache to add the recipe to.
# :param name: The name of the dependency the recipe is for.
# :param module: The find module to use for locating the dependency. Set to the
#     empty string if we are using config files.
function(_cpp_cache_write_find_recipe _ccwfr_cache _ccwfr_name _ccwfr_module)
    _cpp_generate_find_recipe(
            _ccwfr_find_conts ${_ccwfr_name} "${_ccwfr_module}"
    )
    _cpp_cache_add_find_recipe(
        ${_ccwfr_cache} ${_ccwfr_name} "${_ccwfr_find_conts}"
    )
endfunction()

## Wrapper function for generating a build-recipe and adding it to the cache.
#
# :param cache: The CPP cache to add the recipe to.
# :param name: The name of the dependency the recipe is for.
# :param args: CMake variables to pass to the dependency at configure time. Set
#     to the empty string if there are no such variables.
# :param module: The build module for building the dependency. Set to the empty
#     string if CPP can automatically build the dependency.
function(_cpp_cache_write_build_recipe _ccwbr_cache _ccwbr_name _ccwbr_args
                                       _ccwbr_module)
    _cpp_generate_build_recipe(
      _ccwbr_build_conts "${_ccwbr_args}" "${_ccwbr_module}"
    )
    _cpp_cache_add_build_recipe(
        ${_ccwbr_cache} ${_ccwbr_name} "${_ccwbr_build_conts}"
    )
endfunction()
