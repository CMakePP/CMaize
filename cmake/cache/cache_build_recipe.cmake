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
include(cache/cache_paths)

function(_cpp_cache_build_recipe _ccbr_recipe _ccbr_cache _ccbr_name)
    _cpp_cache_build_recipe_path(_ccbr_recipe_path ${_ccbr_cache} ${_ccbr_name})
    _cpp_does_not_exist(_ccbr_dne ${_ccbr_recipe_path})
    if(_ccbr_dne)
        _cpp_error(
            "Build recipe ${_ccbr_recipe_path} does not exist. "
            "Troubleshooting: Did you call _cpp_cache_add_dependency?"
        )
    else()
        set(${_ccbr_recipe} ${_ccbr_recipe_path} PARENT_SCOPE)
    endif()
endfunction()

function(_cpp_cache_add_build_recipe _ccabr_cache _ccabr_name _ccabr_contents)
    _cpp_cache_build_recipe_path(_ccabr_recipe ${_ccabr_cache} ${_ccabr_name})
    _cpp_exists(_ccabr_already_present ${_ccabr_recipe})
    if(_ccabr_already_present)
        file(WRITE ${_ccabr_recipe}.temp "${_ccabr_contents}")
        file(SHA1 ${_ccabr_recipe} _ccabr_old_hash)
        file(SHA1 ${_ccabr_recipe}.temp   _ccabr_new_hash)
        _cpp_are_not_equal(
            _ccabr_different_files ${_ccabr_old_hash} ${_ccabr_new_hash}
        )
        if(_ccabr_different_files)
            _cpp_error(
                "Build recipe ${_ccabr_recipe} already exists and is different"
                " than new build recipe. Troubleshooting: Did you previously "
                " proivde/not provide a build module?"
            )
        endif()
    else()
        file(WRITE ${_ccabr_recipe} "${_ccabr_contents}")
    endif()
endfunction()
