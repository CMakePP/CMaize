function(_cpp_get_gh_url _cggu_return)
    cpp_parse_arguments(
        _cggu "${ARGN}"
        TOGGLES PRIVATE
        OPTIONS URL BRANCH VERSION
        MUST_SET URL
    )
    _cpp_assert_contains("github.com" "${_cggu_URL}")
    _cpp_is_not_empty(_cggu_version_set _cggu_VERSION)
    if(_cggu_version_set)
        _cpp_error("CPP's GitHub capabilities do not support version yet")
    endif()
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

function(_cpp_url_dispatcher _cud_contents _cud_dir _cud_url _cud_version)
    #At the moment we know how to parse GitHub URLs, if the url isn't for GitHub
    #we assume it's a direct download link (download command will fail, if
    #it's not)
    _cpp_contains(_cud_is_gh "github" "${_cud_url}")
    if(_cud_is_gh)
        _cpp_get_gh_url(
            _cud_url URL "${_cud_url}" VERSION "${_cud_version}" ${ARGN}
        )
    endif()
    set(
        ${_cud_contents}
        "_cpp_download_tarball(${_cud_dir} ${_cud_url})"
        PARENT_SCOPE
    )

endfunction()

function(_cpp_get_recipe_dispatch _cgrd_dir)
    cpp_parse_arguments(
        _cgrd "${ARGN}"
        OPTIONS NAME VERSION URL SOURCE_DIR
        MUST_SET NAME
    )
    string(TOLOWER "${_cgrd_NAME}" _cgrd_lc_name)
    set(_cgrd_recipe_name "${_cgrd_dir}/get-${_cgrd_lc_name}.cmake")
    set(_cgrd_tar_name "${_cgrd_dir}/${_cgrd_NAME}.tar.gz")

    #Get the file's contents
    if(_cgrd_URL)
        _cpp_url_dispatcher(
            _cgrd_contents
            "${_cgrd_tar_name}"
            "${_cgrd_URL}"
            "${_cgrd_VERSION}"
            ${_cgrd_UNPARSED_ARGUMENTS}
        )
    elseif(_cgrd_SOURCE_DIR)
        set(
            _cgrd_contents
            "_cpp_tar_directory(${_cgrd_tar_name} ${_cgrd_SOURCE_DIR})"
        )
    else()
        _cpp_error(
            "Not sure how to get source for dependency ${_cgrd_NAME}."
            "Troubleshooting: Did you specify URL or SOURCE_DIR?"
        )
    endif()

    #Check if the get-recipe exists, if so make sure it's the same recipe
    _cpp_exists(_cgrd_exists "${_cgrd_recipe_name}")
    if(_cgrd_exists)
        file(READ "${_cgrd_recipe_name}" _cgrd_old_contents)
        _cpp_are_not_equal(
            _cgrd_different "${_cgrd_old_contents}" "${_cgrd_contents}"
        )
        if(_cgrd_different)
            _cpp_error(
               "Get recipe already exists with different content."
               "Troubleshooting: Did you change where a dependency came from?"
           )
        endif()
    else()
        file(WRITE "${_cgrd_recipe_name}" "${_cgrd_contents}")
    endif()
endfunction()
