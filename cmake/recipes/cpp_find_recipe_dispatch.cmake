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
include(cache/cache_find_module)

function(_cpp_update_find_header _cufh_header _cufh_cache _cufh_name)
    _cpp_cache_find_module(_cufh_recipe ${_cufh_cache} ${_cufh_name})
    get_filename_component(_cufh_dir ${_cufh_recipe} DIRECTORY)
    set(_cufh_mod_path "list(APPEND CMAKE_MODULE_PATH ${_cufh_dir})")
    set(_cufh_orig_header "${${_cufh_header}}")
    set(_cufh_contents "${_cufh_orig_header}\n    ${_cufh_mod_path}")
    set(${_cufh_header} "${_cufh_contents}" PARENT_SCOPE)
endfunction()

function(_cpp_find_recipe_dispatch _cfrd_contents _cfrd_cache _cfrd_name)
    cpp_parse_arguments(_cfrd "${ARGN}" OPTIONS FIND_MODULE)

    #We use a macro b/c we're wrapping find_package which introduces variables
    set(_cfrd_start "macro(_cpp_find_recipe _cfr_version _cfr_comps _cfr_path)")
    set(_cfrd_end "endmacro()")
    _cpp_is_not_empty(_cfrd_have_module _cfrd_FIND_MODULE)
    if(_cfrd_have_module)
        _cpp_cache_add_find_module(
            ${_cfrd_cache} ${_cfrd_name} ${_cfrd_FIND_MODULE}
        )
        _cpp_update_find_header(_cfrd_start ${_cfrd_cache} ${_cfrd_name})
        set(_cfrd_type "module")
    else()
        set(_cfrd_type "config")
    endif()
    #These are the args that get passed to _cpp_find_from_XXX, factored out
    set(_cfrd_args "\"\${_cfr_version}\" \"\${_cfr_comps}\" \"\${_cfr_path}\"")
    set(
        _cfrd_body
"    include(recipes/cpp_find_from_${_cfrd_type})
    _cpp_find_from_${_cfrd_type}(${_cfrd_name} ${_cfrd_args})"
    )

    set(
        ${_cfrd_contents}
        "${_cfrd_start}\n${_cfrd_body}\n${_cfrd_end}"
        PARENT_SCOPE
    )
endfunction()
