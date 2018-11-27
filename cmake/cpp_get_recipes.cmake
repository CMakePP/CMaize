function(_cpp_get_gh_url _cggu_return)
    cpp_parse_arguments(
        _cggu "${ARGN}"
        TOGGLES PRIVATE
        OPTIONS URL VERSION BRANCH
        MUST_SET URL
    )
    _cpp_assert_contains("github.com" "${_cggu_URL}")
    cpp_option(_cggu_BRANCH master)

    #This parses the organization and repo out of the string
    string(REGEX MATCH "github\\.com/([^/]*)/([^/]*)" "" "${_cggu_URL}")
    set(_cggu_org "${CMAKE_MATCH_1}")
    set(_cggu_repo "${CMAKE_MATCH_2}")
    _cpp_debug_print("Organization/User: ${_cggu_org} Repo: ${_cggu_repo}")

    #Handle commandline access to private repositories
    if(_cggu_PRIVATE)
        _cpp_is_not_empty(_cggu_token_set CPP_GITHUB_TOKEN)
        if(NOT _cggu_token_set)
            _cpp_error(
                "For private repos CPP_GITHUB_TOKEN must be a valid token."
                "Trobleshooting: Did you set CPP_GITHUB_TOKEN?"
            )
        endif()
        set(_cggu_token "?access_token=${CPP_GITHUB_TOKEN}")
    endif()
    set(
         _cggu_prefix
         "https://api.github.com/repos/${_cggu_org}/${_cggu_repo}/tarball"
    )
    set(
        ${_cggu_return}
        "${_cggu_prefix}/${_cggu_BRANCH}${_cggu_token}"
        PARENT_SCOPE
    )
endfunction()

function(_cpp_url_dispatcher _cud_contents _cud_url)
    #At the moment we know how to parse GitHub URLs, if the url isn't for GitHub
    #we assume it's a direct download link (download command will fail, if
    #it's not)
    _cpp_contains(_cud_is_gh "github" "${_cud_url}")
    set(_cud_recipe "function(_cpp_get_recipe _cgr_tar _cgr_version)")
    if(_cud_is_gh)
        set(
            _cud_recipe
"${_cud_recipe}
    _cpp_get_gh_url(
        _cgr_url
        URL ${_cud_url}
        ${ARGN}
    )"
        )
    else()
        set(_cud_recipe "${_cud_recipe}\n    set(_cgr_url ${_cud_url})")
    endif()
    set(
        _cud_recipe
"${_cud_recipe}
    _cpp_download_tarball(\${_cgr_tar} \${_cgr_url})
endfunction()"
    )
    set(${_cud_contents} "${_cud_recipe}" PARENT_SCOPE)
endfunction()

function(_cpp_get_recipe_dispatch _cgrd_return)
    cpp_parse_arguments(_cgrd "${ARGN}" OPTIONS URL SOURCE_DIR)
    #Get the file's contents
    if(_cgrd_URL)
        _cpp_url_dispatcher(
            _cgrd_contents
            "${_cgrd_URL}"
            ${_cgrd_UNPARSED_ARGUMENTS}
        )
    elseif(_cgrd_SOURCE_DIR)
        set(
            _cgrd_contents
            "function(_cpp_get_recipe _cgr_tar _cgr_version)
            _cpp_tar_directory(\${_cgr_tar} ${_cgrd_SOURCE_DIR})
            endfunction()"
        )
    else()
        _cpp_error(
            "Not sure how to get source for dependency."
            "Troubleshooting: Did you specify URL or SOURCE_DIR?"
        )
    endif()
    set(${_cgrd_return} "${_cgrd_contents}" PARENT_SCOPE)
endfunction()
