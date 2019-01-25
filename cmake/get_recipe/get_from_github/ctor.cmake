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

include(get_recipe/ctor)
include(get_recipe/get_from_github/assemble_gh_url)
include(get_recipe/get_from_github/parse_gh_url)

## Constructs an instance of the derived GetRecipe type GetFromGithub
#
# :param url: The GitHub URL to download the source from
# :param branch: The branch to use. If blank defaults to master.
# :param private: If true a token will be used to download the repo. Defaults to
#                 false.
function(_cpp_GetFromGithub_ctor _cGc_handle _cGc_url _cGc_branch _cGc_version
                                 _cGc_private)
    _cpp_GetRecipe_ctor(_cGc_temp)
    _cpp_Object_set_type(${_cGc_temp} GetFromGithub)
    _cpp_parse_gh_url(_cGc_org _cGc_repo "${_cGc_url}")
    _cpp_assemble_gh_url(
        _cGc_url
        "${_cGc_org}"
        "${_cGc_repo}"
        "${_cGc_private}"
        "${_cGc_branch}"
        "${_cGc_version}"
    )
    _cpp_Object_set_value(${_cGc_temp} url "${_cGc_url}")
    _cpp_set_return(${_cGc_handle} ${_cGc_temp})
endfunction()
