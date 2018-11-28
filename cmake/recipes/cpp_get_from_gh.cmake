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
                              _cagu_branch)
    set(
        _cagu_prefix
        "https://api.github.com/repos/${_cagu_org}/${_cagu_repo}/tarball"
    )
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
    set(${_cagu_url} ${_cagu_prefix}/${_cagu_branch}${_cagu_token} PARENT_SCOPE)
endfunction()


function(_cpp_get_from_gh _cgfg_tar _cgfg_version _cgfg_url)
    cpp_parse_arguments(_cgfg "${ARGN}" TOGGLES PRIVATE OPTIONS BRANCH)
    _cpp_assert_contains("github.com" "${_cgfg_url}")
    cpp_option(_cgfg_BRANCH master)

    _cpp_parse_gh_url(_cgfg_org _cgfg_repo ${_cgfg_url})
    _cpp_assemble_gh_url(
        _cgfg_url ${_cgfg_org} ${_cgfg_repo} ${_cgfg_PRIVATE} ${_cgfg_BRANCH}
    )

    _cpp_download_tarball(${_cgfg_tar} ${_cgfg_url})
endfunction()
