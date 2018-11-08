function(_cpp_get_gh_url _cggu_return)
    set(_cggu_T_kwargs PRIVATE)
    set(_cggu_O_kwargs URL BRANCH)
    cmake_parse_arguments(
            _cggu
            "${_cggu_T_kwargs}"
            "${_cggu_O_kwargs}"
            ""
            "${ARGN}"
    )
    _cpp_assert_true(_cggu_URL)
    cpp_option(_cggu_BRANCH master)
    _cpp_assert_contains("github.com" "${_cggu_URL}")

    #This parses the organization and repo out of the string
    set(_cggu_string "github.com/")
    string(REGEX MATCH "github\\.com/([^/]*)/([^/]*)" "" "${_cggu_URL}")
    set(_cggu_org "${CMAKE_MATCH_1}")
    set(_cggu_repo "${CMAKE_MATCH_2}")
    _cpp_debug_print("Organization/User: ${_cggu_org} Repo: ${_cggu_repo}")

    if(_cggu_PRIVATE)
        _cpp_is_not_empty(_cggu_token_set CPP_GITHUB_TOKEN)
        if(NOT _cggu_token_set)
            message(
                    FATAL_ERROR
                    "For private repos CPP_GITHUB_TOKEN must be a valid token."
            )
        endif()
        set(_cggu_token "?access_token=${CPP_GITHUB_TOKEN}")
    endif()
    set(
            _cggu_url_prefix
            "https://api.github.com/repos/${_cggu_org}/${_cggu_repo}/tarball"
    )
    set(
            ${_cggu_return}
            "${_cggu_url_prefix}/${_cggu_BRANCH}${_cggu_token}"
            PARENT_SCOPE
    )
endfunction()

function(_cpp_get_source_tarball _cgrt_file)
    set(_cgrt_O_kwargs URL SOURCE_DIR)
    cmake_parse_arguments(_cgrt "" "${_cgrt_O_kwargs}" "" "${ARGN}")
    if(_cgrt_URL)
        _cpp_debug_print("Getting source from URL: ${_cgrt_URL}")
    endif()
    if(_cgrt_SOURCE_DIR)
        _cpp_debug_print("Getting source from dir: ${_cgrt_SOURCE_DIR}")
    endif()
    _cpp_xor(_cgrt_one_set _cgrt_URL _cgrt_SOURCE_DIR)
    if(NOT _cgrt_one_set)
        message(FATAL_ERROR "Please specify either URL or SOURCE_DIR")
    endif()

    _cpp_contains(_cgrt_is_gh "github.com/" "${_cgrt_URL}")

    if(_cgrt_SOURCE_DIR)
        #User gave us /a/long/path/to/here and we want the tarball to untar to
        #just here
        get_filename_component(_cgrt_work_dir "${_cgrt_SOURCE_DIR}" DIRECTORY)
        get_filename_component(_cgrt_dir "${_cgrt_SOURCE_DIR}" NAME)
        execute_process(
                COMMAND ${CMAKE_COMMAND} -E tar "cfz" "${_cgrt_file}" "${_cgrt_dir}"
                WORKING_DIRECTORY ${_cgrt_work_dir}
        )
        return()
    endif()

    #Determine the URL to call to get the tarball
    if(_cgrt_is_gh)
        _cpp_get_gh_url(_cgrt_url2call "${ARGN}")
    else()
        set(_cgrt_msg "${_cgrt_URL} does not appear to be a valid URL.")
        message(
                FATAL_ERROR
                "${_cgrt_msg} Only GitHub URLs are supported at this time."
        )
    endif()
    #Actually get it
    file(DOWNLOAD "${_cgrt_url2call}" "${_cgrt_file}")
endfunction()
