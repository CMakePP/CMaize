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
include(utility/set_return)

## Function that wraps the GitLab URL API
#
# The GitLab URL API is similar to the GitHub one. It starts with
# ``http://gitlab.com/${organization}/${repo}``. Next is an optional tag.
# Finally is ``archive.tar.gz``, which appears to be the name that the source
# will be downloaded as.
#
# :param url: The identifier which will contain the returned URL.
# :param org: The GitLab organization which owns the repository.
# :param repo: The repository to access.
# :param version: The version of the source
function(_cpp_assemble_gl_url _cagu_url _cagu_org _cagu_repo _cagu_version)
    set(_cagu_base "http://gitlab.com/${_cagu_org}/${_cagu_repo}")

    _cpp_are_not_equal(_cagu_not_latest "${_cagu_version}" "latest")
    if(_cagu_not_latest)
        set(_cagu_base "${_cagu_base}/${_cagu_version}")
    endif()

    set(_cagu_base "${_cagu_base}/archive.tar.gz")
    _cpp_set_return(_cagu_url ${_cagu_base})
endfunction()
