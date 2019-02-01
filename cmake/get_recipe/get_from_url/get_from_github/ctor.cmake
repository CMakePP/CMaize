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
include(get_recipe/get_from_url/ctor)
include(get_recipe/get_from_url/get_from_github/assemble_gh_url)
include(get_recipe/get_from_url/get_from_github/parse_gh_url)
include(utility/set_return)

## Constructs an instance of the derived GetRecipe type GetFromGithub
#
# :param url: The GitHub URL to download the source from
# :param branch: The branch to use. If blank defaults to master.
# :param name: The name of the dependency.
# :param private: If true a token will be used to download the repo. Defaults to
#                 false.
function(_cpp_GetFromGithub_ctor _cGc_handle _cGc_url _cGc_branch _cGc_name
                                 _cGc_version _cGc_private)
    _cpp_does_not_contain(_cGc_is_not_gh "github" "${_cGc_url}")
    if(_cGc_is_not_gh)
        _cpp_error("URL: ${_cGc_url} does not appear to be a GitHub URL.")
    endif()

    cpp_option(_cGc_branch  "master")
    _cpp_parse_gh_url(_cGc_org _cGc_repo "${_cGc_url}")
    _cpp_assemble_gh_url(
        _cGc_url
        "${_cGc_org}"
        "${_cGc_repo}"
        "${_cGc_private}"
        "${_cGc_branch}"
        "${_cGc_version}"
    )
    _cpp_GetFromURL_ctor(
        _cGc_temp "${_cGc_url}" "${_cGc_name}" "${_cGc_version}"
    )
    _cpp_Object_set_type(${_cGc_temp} GetFromGithub)
    _cpp_set_return(${_cGc_handle} ${_cGc_temp})
endfunction()
