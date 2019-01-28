include_guard()
include(find_recipe/handle_found_var)
include(find_recipe/handle_target_vars)
include(find_recipe/find_from_config/handle_dir)

function(_cpp_FindFromConfig_find_dependency _cFfd_handle _cFfd_version
                                             _cFfd_comps _cFfd_paths)
    _cpp_Object_get_value(${_cFfd_handle} _cFfd_name name)

    #CMake doesn't append the additional search path onto prefix path so
    #dependencies relying on prefix_path to find their dependencies won't find
    #them without this next line
    list(APPEND CMAKE_PREFIX_PATH ${_cFfd_paths})
    find_package(
        ${_cFfd_name}
        ${_cFfd_version}
        ${_cFfd_comps}
        CONFIG
        QUIET
        PATHS "${_cffc_path}"
        NO_PACKAGE_ROOT_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_PACKAGE_REGISTRY
        NO_CMAKE_SYSTEM_PATH
        NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
    )
    _cpp_FindFromConfig_handle_dir(${_cFfd_handle})
    _cpp_FindRecipe_handle_found_var(${_cFfd_handle})
    _cpp_Object_get_value(${_cFfd_handle} _cFfd_found found)
    if("${_cFfd_found}")
        _cpp_handle_target_vars(${_cFfd_name})
    endif()
endfunction()
