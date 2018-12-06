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

include(dependency/cpp_sanitize_version)

#Pulled this function out to avoid contaminating the namespace
function(_cpp_check_for_module _ccfm_name)
    find_file(
        _ccfm_found
        "Find${_ccfm_name}.cmake"
        PATHS ${CMAKE_MODULE_PATH}
     #   NO_DEFAULT_PATH
    )
    _cpp_contains(_ccfm_module_not_found "NOTFOUND" "${_ccfm_found}")
    if(_ccfm_module_not_found)
        _cpp_error(
            "Find${_ccfm_name}.cmake was not found in CMAKE_MODULE_PATH."
            "CMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}."
        )
    endif()
endfunction()

macro(_cpp_find_from_module _cffm_name _cffm_version _cffm_comps _cffm_path)
    _cpp_check_for_module(${_cffm_name})
    list(APPEND CMAKE_PREFIX_PATH ${_cffm_path})
    _cpp_sanitize_version(_cffm_temp "${_ccfm_version}")
    find_package(${_cffm_name} ${_cffm_temp} ${_cffm_comps} MODULE QUIET)
endmacro()
