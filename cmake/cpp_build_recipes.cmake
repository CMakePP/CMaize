include(ExternalProject)
include(cpp_options)
include(cpp_checks)
include(cpp_print)
include(cpp_assert)

function(cpp_local_cmake _clc_name _clc_dir)
    ExternalProject_Add(
        ${_clc_name}_External
        SOURCE_DIR ${_clc_dir}
        INSTALL_DIR ${CMAKE_BINARY_DIR}/install
        CMAKE_ARGS -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
                   -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}

    )
endfunction()

function(_cpp_parse_gh_url _cpgu_return _cpgu_url)
    #Strategy: find github.com, move cursor to organization, get rest

    string(FIND ${_cpgu_url} "github.com/" _cpgu_gh_location)
    _cpp_assert_not_equal("${_cpgu_gh_location}" "-1")
    math(EXPR _cpgu_start "${_cpgu_gh_location} + 11")
    string(SUBSTRING ${_cpgu_url} ${_cpgu_start} -1 _cpgu_short_url)
    set(${_cpgu_return} ${_cpgu_short_url} PARENT_SCOPE)
endfunction()


function(cpp_github_cmake _cgc_name _cgc_url)
    _cpp_parse_gh_url(_cgc_repo ${_cgc_url})
    set(_cgc_O_kwargs TOKEN BRANCH)
    set(_cgc_M_kwargs CMAKE_ARGS)
    cmake_parse_arguments(
        _cgc
        ""
        "${_cgc_O_kwargs}"
        "${_cgc_M_kwargs}"
        ${ARGN}
    )

    set(_cgc_gh_api "https://api.github.com/repos")

    _cpp_option(_cgc_BRANCH master)
    _cpp_non_empty(_cgc_token_set _cgc_TOKEN)
    set(_cgc_token)
    if(_cgc_token_set)
        set(_cgc_token "?access_token=${_cgc_TOKEN}")
    endif()
    set(
        _cgc_url
        "${_cgc_gh_api}/${_cgc_repo}/tarball/${_cgc_BRANCH}${_cgc_token}"
    )

    set(_crsb_add_args)
    foreach(_cgc_arg ${_cgc_CMAKE_ARGS})
        list(APPEND _cgc_add_args "-D${_crgc_arg}")
    endforeach()
    _cpp_debug_print("Building CMake project at URL: ${_cgc_url}")
    ExternalProject_Add(
        ${_cgc_name}_External
        URL ${_cgc_url}
        INSTALL_DIR ${CMAKE_BINARY_DIR}/install
        CMAKE_ARGS -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
                   -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
                   ${_cgc_add_args}
    )
endfunction()
