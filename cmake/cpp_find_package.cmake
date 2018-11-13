macro(_cpp_find_from_config _cffc_name _cffc_version _cffc_comps _cffc_path)
    #This only honors CMAKE_PREFIX_PATH and whatever paths were provided
    find_package(
        ${_cffc_name}
        ${_cffc_version}
        ${_cffc_comps}
        CONFIG
        QUIET
        PATHS "${_cffc_path}"
        NO_PACKAGE_ROOT_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_PACKAGE_REGISTRY
        NO_CMAKE_SYSTEM_PATH
        NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
    )
endmacro()

macro(_cpp_find_from_module _cffm_name _cffm_version _cffm_comps)
    find_package(
            ${_cgfs_name}
            ${_cgfs_version}
            ${_cgfs_comps}
            MODULE
            QUIET
    )
endmacro()



function(_cpp_generic_find_search _cgfs_found _cgfs_name _cgfs_version
        _cgfs_comps _cgfs_path)

    #Will change this if not the case
    set(${_cgfs_found} TRUE PARENT_SCOPE)

    #Check if target exists, if so return
    _cpp_is_target(_cgfs_exists "${_cgfs_name}")
    if(_cgfs_exists)
        return()
    endif()

    get_directory_property(
            _cgfs_old_targets
            DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            BUILDSYSTEM_TARGETS
    )

    #Being blunt we only want to use modules if the user provides them since
    #CMake's versions suck...
    _cpp_exists(_cgfs_has_recipe "${_cgfs_path}/Find${_cgfs_name}.cmake")
    if(_cgfs_has_recipe)
        list(APPEND CMAKE_MODULE_PATH "${_cffm_path}")
        _cpp_find_from_module(${_cgfs_name} "${_cgfs_version}" "${_cgfs_comps}")
    else()
        _cpp_find_from_config(
                ${_cgfs_name} "${_cgfs_version}" "${_cgfs_comps}" "${_cgfs_path}"
        )
    endif()

    if(NOT ${_cgfs_name}_FOUND)
        set(${_cgfs_found} FALSE PARENT_SCOPE)
        return()
    endif()

    #Determine if new targets were made
    get_directory_property(
            _cgfs_targets
            DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            BUILDSYSTEM_TARGETS
    )
    list(APPEND _cgfs_targets ${_cgfs_old_targets})
    list(LENGTH _cgfs_targets _cgfs_n)
    if(${_cgfs_n} GREATER 0)
        list(REMOVE_DUPLICATES _cgfs_targets)
        list(LENGTH _cgfs_targets _cgfs_n_new)
        if(${_cgfs_n_new} GREATER 0)
            _cpp_debug_print("New targets: ${_cgfs_targets}")
            return()
        endif()
    endif()

    #Didn't get a target, assume the dependency set the standard CMake variables
    add_library(${_cgfs_name} INTERFACE)
    string(TOUPPER ${_cgfs_name} _cgfs_uc_name)
    strign(TOLOWER ${_cgfs_name} _cgfs_lc_name)
    foreach(_cgfs_var ${_cgfs_name} ${_cgfs_uc_name} ${_cgfs_lc_name})
        set(_cgfs_include ${_cgfs_var}_INCLUDE_DIRS)
        _cpp_is_not_empty(_cgfs_has_incs _cgfs_include)
        if(_cgfs_has_incs)
            target_include_directories(${_cgfs_name} INTERFACE ${_cgfs_include})
        endif()
        set(_cgfs_lib ${_cgfs_var}_LIBRARIES)
        _cpp_is_not_empty(_cgfs_has_libs _cgfs_lib)
        if(_cgfs_has_libs)
            target_link_libraries(${_cgfs_name} INTERFACE ${_cgfs_lib})
        endif()
    endforeach()
endfunction()
