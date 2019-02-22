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
include(get_recipe/get_from_url/get_from_gitlab/ctor_add_kwargs)
include(get_recipe/get_from_url/url_parser)
include(get_recipe/get_from_url/get_from_gitlab/assemble_gl_url)
include(kwargs/kwargs)
include(utility/set_return)

## Constructs an instance of the derived GetRecipe type GetFromGitLab
#
# :param handle: An identifier whose value will be the newly created object.
# :param url: The GitLab URL to download the source from
# :param kwargs: A Kwargs object containing the user-supplied options
#
# :kwargs:
#   * *VERSION* - The release to get
#   * *BRANCH*  - The branch or commit to get
function(_cpp_GetFromGitLab_ctor _cGc_handle _cGc_url _cGc_kwargs)
    _cpp_GetFromGitLab_ctor_add_kwargs(${_cGc_kwargs})
    _cpp_Kwargs_parse_argn(${_cGc_kwargs} ${ARGN})
    _cpp_Kwargs_kwarg_value(${_cGc_kwargs} _cGc_version VERSION)
    _cpp_Kwargs_kwarg_value(${_cGc_kwargs} _cGc_branch BRANCH)

    _cpp_does_not_contain(_cGc_is_not_gh "gitlab" "${_cGc_url}")
    if(_cGc_is_not_gh)
        _cpp_error("URL: ${_cGc_url} does not appear to be a GitLab URL.")
    endif()

    _cpp_url_parser(_cGc_org _cGc_repo "${_cGc_url}")
    _cpp_assemble_gl_url(
        _cGc_url
        ${_cGc_org}
        ${_cGc_repo}
        ${_cGc_version}
        ${_cGc_branch}
    )
    message("Settting the URL to: ${_cGc_url}")
    _cpp_GetFromURL_ctor(_cGc_temp "${_cGc_url}" ${_cGc_kwargs})
    _cpp_Object_set_type(${_cGc_temp} GetFromGitLab)
    _cpp_set_return(${_cGc_handle} ${_cGc_temp})
endfunction()
