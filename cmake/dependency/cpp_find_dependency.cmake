include_guard()
include(dependency/cpp_special_find)
include(dependency/cpp_find_package)
include(dependency/cpp_record_find)
include(cache/cache_paths)

function(cpp_find_dependency)
    cpp_parse_arguments(
            _cfd "${ARGN}"
            TOGGLES OPTIONAL
            OPTIONS NAME VERSION RESULT CPP_CACHE PATH FIND_MODULE TOOLCHAIN
            LISTS COMPONENTS
            MUST_SET NAME
    )
    cpp_option(_cfd_RESULT CPP_DEV_NULL)
    cpp_option(_cfd_CPP_CACHE ${CPP_INSTALL_CACHE})
    cpp_option(_cfd_TOOLCHAIN ${CMAKE_TOOLCHAIN_FILE})

    if(_cfd_OPTIONAL)
        set(_cfd_optional "OPTIONAL")
    endif()

    _cpp_record_find(
        "cpp_find_dependency"
        NAME "${_cfd_NAME}"
        VERSION "${_cfd_VERSION}"
        COMPONENTS "${_cfd_COMPONENTS}"
        ${_cfd_optional}
    )

    if(_cfd_FIND_MODULE)
        _cpp_find_recipe_dispatch(
            _cfd_contents
            ${_cfd_CPP_CACHE}
            ${_cfd_NAME}
            FIND_MODULE "${_cfd_FIND_MODULE}"
        )
        _cpp_cache_add_find_recipe(
            ${_cfd_CPP_CACHE} ${_cfd_NAME} ${_cfd_contents}
        )
    endif()

    #Honor special variables
    _cpp_special_find(
        _cfd_found
        ${_cfd_CPP_CACHE}
        ${_cfd_NAME}
        "${_cfd_VERSION}"
        "${_cfd_COMPONENTS}"
    )

    if(${_cfd_found})
        return()
    endif()

    _cpp_cache_install_path(
        _cfd_path ${_cfd_CPP_CACHE} ${_cfd_NAME} "${_cfd_VERSION}"
        "${_cfd_TOOLCHAIN}"
    )

    _cpp_find_package(
        _cfd_found
        ${_cfd_CPP_CACHE}
        ${_cfd_NAME}
        "${_cfd_VERSION}"
        "${_cfd_COMPONENTS}"
        "${_cfd_path}"
    )
    if(${_cfd_found} OR ${_cfd_OPTIONAL})
        set(${_cfd_RESULT} ${_cfd_found} PARENT_SCOPE)
        return()
    endif()

    _cpp_error(
        "Could not locate ${_cfd_NAME}"
        "Troubleshooting: Is the path to ${_cfd_NAME} in CMAKE_PREFIX_PATH?"
        "   (current value of CMAKE_PREFIX_PATH is: ${CMAKE_PREFIX_PATH})"
    )

endfunction()
