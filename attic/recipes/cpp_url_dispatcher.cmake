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
include(recipes/cpp_get_from_gh)

## Function which dispatches among the URL protocals we know.
#
# At the moment this function looks for two things: is "github" in the URL and
# is "gz" in the URL. If the latter is found we assume this is a direct link to
# a tarball. If the former is found we assume the dependency's source is hosted
# on GitHub. If both are found we assume the user linked to a specific uploaded
# asset and bypass the GitHub URL protocol.
#
# :param tar: The path where the tarball of the dependency should go.
# :param version: The version of the dependency we should download.
# :param url: The URL to download the dependency from.
# :param private: True if we are obtaining the source from a private GitHub
#     repository, and False otherwise. Ignored if URL is not for GitHub.
# :param branch: The branch of the source code to use. Ignored if the dependency
#     is not managed by git.
#
# :CMake Variables:
#
#     * *CPP_GITHUB_TOKEN* - Used to get the user's GitHub access token if we
#       are cloning a private GitHub repository.
function(_cpp_url_dispatcher _cud_tar _cud_version _cud_url _cud_private
                             _cud_branch)
    #At the moment we know how to parse GitHub URLs, if the url isn't for GitHub
    #we assume it's a direct download link (download command will fail, if
    #it's not)
    _cpp_contains(_cud_is_gh "github" "${_cud_url}")
    _cpp_contains(_cud_is_tar "gz" "${_cud_url}")
    if(${_cud_is_gh} AND ${_cud_is_tar}) #User linked to a specific asset,
        _cpp_download_tarball(${_cud_tar} ${_cud_url})
    elseif(_cud_is_gh)
        _cpp_get_from_gh(
          ${_cud_tar}
          "${_cud_version}"
          "${_cud_url}"
          "${_cud_private}"
          "${_cud_branch}"
        )
    else()
       _cpp_download_tarball(${_cud_tar} ${_cud_url})
    endif()
endfunction()
