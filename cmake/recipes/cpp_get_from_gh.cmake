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

## Function which parses the organization and repository out of a GitHub URL
#
# This function will take a GitHub URL of the form ``github.com/org/repo`` and
# parse out the organization and repository. The actual parsing is insensitive
# to whether or not generic prefixes like ``www.`` and ``https://`` are present.
# The function will raise errors if an organization or a repository is not
# present.
#
# :param org: The identifier to store the organization's name under.
# :param repo: The identifier to store the repository's name under.
# :param url: The URL that we are parsing.
function(_cpp_parse_gh_url _cpgu_org _cpgu_repo _cpgu_url)
    string(REGEX MATCH "github\\.com/([^/]*)/([^/]*)" "" "${_cpgu_url}")
    set(${_cpgu_org} "${CMAKE_MATCH_1}")
    set(${_cpgu_repo} "${CMAKE_MATCH_2}")

    _cpp_is_empty(_cpgu_dont_have_org ${_cpgu_org})
    if(_cpgu_dont_have_org)
        _cpp_error(
           "URL: ${_cpgu_url} does not appear to contain an organization or "
           "user. Troubleshooting: ensure URL is of the form "
           "github.com/<organization>/<repo>."
           )
    endif()
    _cpp_is_empty(_cpgu_dont_have_repo ${_cpgu_repo})
    if(_cpgu_dont_have_repo)
        _cpp_error(
           "URL: ${_cpgu_url} does not appear to contain a repository. "
           "Troubleshooting: ensure URL is of the form "
           "github.com/<organization>/<repo>."
        )
    endif()

    set(${_cpgu_org} ${${_cpgu_org}} PARENT_SCOPE)
    set(${_cpgu_repo} ${${_cpgu_repo}} PARENT_SCOPE)
endfunction()

## Function that wraps the GitHub URL API
#
# This function takes the various pieces of input and assembles the URL to use
# to retrieve the spefied version of a dependency hosted on GitHub. This
# function is responsible for handleing the ``PRIVATE`` kwarg and will error if
# the user has not set ``CPP_GITHUB_TOKEN``.
#
# :param url: The identifier which will contain the returned URL.
# :param org: The GitHub organization which owns the repository.
# :param repo: The repository to access.
# :param private: True if this is a private GitHub repository, False if public.
# :param branch: The git branch to use.
# :param version: The version of the dependency to clone.
#
# :CMake Variables:
#
#     * *CPP_GITHUB_TOKEN* - Used to get the user's GitHub access token if we
#       are cloning a private repository.
function(_cpp_assemble_gh_url _cagu_url _cagu_org _cagu_repo _cagu_private
                              _cagu_branch _cagu_version)

    set(
        _cagu_prefix
        "https://api.github.com/repos/${_cagu_org}/${_cagu_repo}/tarball"
    )
    _cpp_is_not_empty(_cagu_have_version _cagu_version)

    if(_cagu_have_version)
        set(_cagu_tar "${_cagu_version}")
    else()
        set(_cagu_tar "${_cagu_branch}")
    endif()

    #Handle commandline access to private repositories
    if(_cagu_private)
        _cpp_is_not_empty(_cagu_token_set CPP_GITHUB_TOKEN)
        if(NOT _cagu_token_set)
            _cpp_error(
                "For private repos CPP_GITHUB_TOKEN must be a valid token."
                "Troubleshooting: Did you set CPP_GITHUB_TOKEN?"
            )
        endif()
        set(_cagu_token "?access_token=${CPP_GITHUB_TOKEN}")
    endif()
    set(${_cagu_url} ${_cagu_prefix}/${_cagu_tar}${_cagu_token} PARENT_SCOPE)
endfunction()

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
