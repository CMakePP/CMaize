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
    _cpp_are_not_equal(_cagu_have_version "${_cagu_version}" "latest")

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
    _cpp_set_return(${_cagu_url} ${_cagu_prefix}/${_cagu_tar}${_cagu_token})
endfunction()
