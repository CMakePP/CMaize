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
include(get_recipe/get_from_disk/get_from_disk)
include(get_recipe/get_from_url/get_from_url)

## Function for encapsulating the logic surrounding how to get a dependency
#
#
function(_cpp_GetRecipe_factory _cGf_handle)
    set(_cGf_O_kwargs NAME VERSION BRANCH URL SOURCE_DIR)
    cmake_parse_arguments(_cGf "PRIVATE" "${_cGf_O_kwargs}" "" ${ARGN})

    _cpp_xor(_cGf_dir_or_url _cGf_URL _cGf_SOURCE_DIR)
    _cpp_negate(_cGf_dir_or_url "${_cGf_dir_or_url}")
    if(_cGf_dir_or_url)
        _cpp_error("Please specify one (and only one) of SOURCE_DIR or URL")
    endif()

    _cpp_is_not_empty(_cGf_is_url _cGf_URL)
    if(_cGf_is_url)
        _cpp_GetFromURL_factory(
            _cGf_temp
            "${_cGf_URL}"
            "${_cGf_BRANCH}"
            "${_cGf_NAME}"
            "${_cGf_VERSION}"
            "${_cGf_PRIVATE}"
        )
    else()
        _cpp_GetFromDisk_ctor(
            _cGf_temp "${_cGf_SOURCE_DIR}" "${_cGf_NAME}" "${_cGf_VERSION}"
        )
    endif()
    _cpp_set_return(${_cGf_handle} "${_cGf_temp}")
endfunction()
