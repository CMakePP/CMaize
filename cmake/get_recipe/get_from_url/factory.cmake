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
include(get_recipe/get_from_url/get_from_github/get_from_github)
include(get_recipe/get_from_url/ctor)

## Dispatches among the various way to get source from the internet.
#
# This function is responsible for calling the correct ctor for the various
# classes derived from the ``GetFromURL`` class.
#
#
# :param handle: An identifier to hold the handle to the returned object.
# :param url: The URL to get the source from.
# :param branch: The branch of the source code to use.
# :param name: The name of the dependency
# :param version: The version of the source code this recipe is for.
# :param private: If true this source comes from a private GitHub repo
function(_cpp_GetFromURL_factory _cGf_handle _cGf_url _cGf_branch _cGf_name
                                 _cGf_version _cGf_private)
    _cpp_contains(_cGf_is_gh "github.com" "${_cGf_url}" )
    if(_cGf_is_gh)
        _cpp_GetFromGithub_ctor(
            _cGf_temp
            "${_cGf_url}"
            "${_cGf_branch}"
            "${_cGf_name}"
            "${_cGf_version}"
            "${_cGf_private}"
        )
    else()
        _cpp_GetFromURL_ctor(
           _cGf_temp "${_cGf_url}" "${_cGf_name}" "${_cGf_version}"
        )
    endif()
    _cpp_set_return(${_cGf_handle} ${_cGf_temp})
endfunction()
