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


function(_cpp_get_from_gh _cgfg_tar _cgfg_version _cgfg_url)
    cpp_parse_arguments(_cgfg "${ARGN}" TOGGLES PRIVATE OPTIONS BRANCH)
    _cpp_assert_contains("github.com" "${_cgfg_url}")
    cpp_option(_cgfg_BRANCH master)

    _cpp_parse_gh_url(_cgfg_org _cgfg_repo ${_cgfg_url})
    _cpp_assemble_gh_url(
        _cgfg_url
        ${_cgfg_org}
        ${_cgfg_repo}
        ${_cgfg_PRIVATE}
        ${_cgfg_BRANCH}
        "${_cgfg_version}"
    )

    _cpp_download_tarball(${_cgfg_tar} ${_cgfg_url})
endfunction()

function(_cpp_gh_get_recipe_body _cggrb_output _cggrb_url)
    #Can't just dump the args as the order may change invalidating memoiztion
    cpp_parse_arguments(_cggrb "${ARGN}" TOGGLES PRIVATE OPTIONS BRANCH)
    set(_cggrb_include "include(recipes/cpp_get_from_gh)")
    set(_cggrb_cmd              "_cpp_get_from_gh(\n")
    set(_cggrb_cmd "${_cggrb_cmd}    \${_cgr_tar}\n")
    set(_cggrb_cmd "${_cggrb_cmd}    \"\${_cgr_version}\"\n")
    set(_cggrb_cmd "${_cggrb_cmd}    ${_cggrb_url}\n")
    if(_cggrb_PRIVATE)
        set(_cggrb_cmd "${_cggrb_cmd}    PRIVATE\n")
    endif()
    _cpp_is_not_empty(_cggrb_have_branch _cggrb_BRANCH)
    if(_cggrb_have_branch)
        set(_cggrb_cmd "${_cggrb_cmd}    BRANCH ${_cggrb_BRANCH}\n")
    endif()
    set(_cggrb_cmd "${_cggrb_cmd})")
    set(${_cggrb_output} "${_cggrb_include}\n${_cggrb_cmd}" PARENT_SCOPE)
endfunction()
