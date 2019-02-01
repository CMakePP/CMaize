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

function(_cpp_cache_find_module _ccfm_recipe _ccfm_cache _ccfm_name)
    _cpp_cache_find_module_path(_ccfm_recipe_path ${_ccfm_cache} ${_ccfm_name})
    _cpp_does_not_exist(_ccfm_dne ${_ccfm_recipe_path})
    if(_ccfm_dne)
        _cpp_error(
            "Find module recipe ${_ccfm_recipe_path} does not exist. "
            "Troubleshooting: Did you call _cpp_cache_add_dependency?"
        )
    else()
        set(${_ccfm_recipe} ${_ccfm_recipe_path} PARENT_SCOPE)
    endif()
endfunction()

function(_cpp_cache_add_find_module _ccafm_cache _ccafm_name _ccafm_contents)
    _cpp_cache_find_module_path(_ccafm_recipe ${_ccafm_cache} ${_ccafm_name})
    _cpp_exists(_ccafm_already_present ${_ccafm_recipe})
    if(_ccafm_already_present)
        file(SHA1 ${_ccafm_recipe} _ccafm_old_hash)
        file(SHA1 ${_ccafm_contents} _ccafm_new_hash)
        _cpp_are_not_equal(
            _ccafm_different_files ${_ccafm_old_hash} ${_ccafm_new_hash}
        )
        if(_ccafm_different_files)
            _cpp_error(
                "Find module ${_ccafm_recipe} already exists and is different"
                " than new find module. Troubleshooting: Did you previously "
                " proivde a different find module?"
            )
        endif()
    else()
        configure_file(${_ccafm_contents} ${_ccafm_recipe} COPYONLY)
    endif()
endfunction()
