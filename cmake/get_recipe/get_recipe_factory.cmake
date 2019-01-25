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
include(logic/xor)
include(logic/negate)
include(get_recipe/get_from_github/ctor)

function(_cpp_GetRecipe_factory _cGf_handle)
    cpp_parse_arguments(
       _cGf "${ARGN}"
       TOGGLES PRIVATE
       OPTIONS VERSION BRANCH URL SOURCE_DIR
    )
    _cpp_xor(_cGf_dir_or_url _cGf_URL _cGf_SOURCE_DIR)
    _cpp_negate(_cGf_dir_or_url "${_cgf_dir_or_url}")
    if(_cGf_dir_or_url)
        _cpp_error("Please specify one (and only one) of SOURCE_DIR or URL")
    endif()

    _cpp_is_not_empty(_cGf_is_url _cGf_URL)
    if(_cGf_is_url)
        cpp_option(_cGf_BRANCH  "master")
        _cpp_contains(_cGf_is_gh "${_cGf_URL}" "github.com")
        if(_cGf_is_gh)
            _cpp_GetFromGithub_ctor(
                ${_cGf_handle}
                "${_cGf_URL}"
                "${_cGf_BRANCH}"
                "${_cGf_VERSION}"
                ${_cGf_PRIVATE}
            )
        endif()
    else()
        _cpp_GetFromDisk_ctor(

        )
    endif()
    _cpp_set_return(${_cGf_handle} "${${_cGf_handle}}")
endfunction()
