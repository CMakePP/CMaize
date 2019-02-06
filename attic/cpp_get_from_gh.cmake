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





## Function wrapping the process of downloading source code from GitHub.
#
# :param tar: The path to where the tarball should go, including the tarball
#     name.
# :param version: The version of the dependency to obtain.
# :param url: The URL to the GitHub repository.
# :param private: True if this is a private GitHub repository and False
#     otherwise.
# :param branch: The branch of the source to use. Defaults to ``master`` if the
#     empty string is passed.
#
# :CMake Variables:
#
#     * *CPP_GITHUB_TOKEN* - Used to get the user's GitHub access token if we
#       are cloning a private repository.
function(_cpp_get_from_gh _cgfg_tar _cgfg_version _cgfg_url _cgfg_private
                          _cgfg_branch)
    _cpp_assert_contains("github.com" "${_cgfg_url}")
    cpp_option(_cgfg_branch master)

    _cpp_parse_gh_url(_cgfg_org _cgfg_repo ${_cgfg_url})
    _cpp_assemble_gh_url(
        _cgfg_url
        ${_cgfg_org}
        ${_cgfg_repo}
        ${_cgfg_private}
        ${_cgfg_branch}
        "${_cgfg_version}"
    )

    _cpp_download_tarball(${_cgfg_tar} ${_cgfg_url})
endfunction()
