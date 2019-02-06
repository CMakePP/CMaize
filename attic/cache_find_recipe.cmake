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

function(_cpp_cache_find_recipe _ccfr_recipe _ccfr_cache _ccfr_name)
    _cpp_cache_find_recipe_path(_ccfr_recipe_path ${_ccfr_cache} ${_ccfr_name})
    _cpp_does_not_exist(_ccfr_dne ${_ccfr_recipe_path})
    if(_ccfr_dne)
        _cpp_error(
            "Find recipe ${_ccfr_recipe_path} does not exist. "
            "Troubleshooting: Did you call _cpp_cache_add_dependency?"
        )
    else()
        set(${_ccfr_recipe} ${_ccfr_recipe_path} PARENT_SCOPE)
    endif()
endfunction()

function(_cpp_cache_add_find_recipe _ccafr_cache _ccafr_name _ccafr_contents)
    _cpp_cache_find_recipe_path(_ccafr_recipe ${_ccafr_cache} ${_ccafr_name})
    _cpp_exists(_ccafr_already_present ${_ccafr_recipe})
    if(_ccafr_already_present)
        file(WRITE ${_ccafr_recipe}.temp "${_ccafr_contents}")
        file(SHA1 ${_ccafr_recipe} _ccafr_old_hash)
        file(SHA1 ${_ccafr_recipe}.temp   _ccafr_new_hash)
        _cpp_are_not_equal(
            _ccafr_different_files ${_ccafr_old_hash} ${_ccafr_new_hash}
        )
        if(_ccafr_different_files)
            _cpp_error(
                "Find recipe ${_ccafr_recipe} already exists and is different"
                " than new find recipe. Troubleshooting: Did you previously "
                " proivde/not provide a find module?"
            )
        endif()
    else()
        file(WRITE ${_ccafr_recipe} "${_ccafr_contents}")
    endif()
endfunction()
