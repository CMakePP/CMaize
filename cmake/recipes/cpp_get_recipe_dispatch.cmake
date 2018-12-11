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
include(recipes/cpp_url_dispatcher)

function(_cpp_get_recipe_kwargs _cgrk_toggles _cgrk_options _cgrk_lists)
    set(${_cgrk_toggles} PRIVATE PARENT_SCOPE)
    set(${_cgrk_options} URL SOURCE_DIR BRANCH PARENT_SCOPE)
    set(${_cgrk_lists} "" PARENT_SCOPE)
endfunction()

function(_cpp_get_recipe_dispatch _cgrd_return)
    _cpp_get_recipe_kwargs(_cgrd_toggles _cgrd_options _cgrd_lists)
    cpp_parse_arguments(
        _cgrd "${ARGN}"
        TOGGLES ${_cgrd_toggles}
        OPTIONS ${_cgrd_options}
        LISTS ${_cgrd_lists}
    )
    set(_cgrd_header "function(_cpp_get_recipe _cgr_tar _cgr_version)")
    set(_cgrd_footer "endfunction()")

    #Get the file's contents
    if(_cgrd_URL)
        _cpp_url_dispatcher(
            _cgrd_body "${_cgrd_URL}" ${_cgrd_UNPARSED_ARGUMENTS}
        )
    elseif(_cgrd_SOURCE_DIR)
        set(_cgrd_body "_cpp_tar_directory(\${_cgr_tar} ${_cgrd_SOURCE_DIR})")
    else()
        _cpp_error(
            "Not sure how to get source for dependency."
            "Troubleshooting: Did you specify URL or SOURCE_DIR?"
        )
    endif()
    set(
        ${_cgrd_return}
        "${_cgrd_header}\n${_cgrd_body}\n${_cgrd_footer}"
        PARENT_SCOPE
    )
endfunction()
