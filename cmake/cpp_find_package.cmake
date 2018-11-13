include_guard()

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
        ${_cffm_name}
        ${_cffm_version}
        ${_cffm_comps}
        MODULE
#        QUIET
    )
endmacro()



function(_cpp_find_package _cfp_found _cfp_name _cfp_version _cfp_comps
                           _cfp_path)

    #Will change this if not the case
    set(${_cfp_found} TRUE PARENT_SCOPE)

    #Check if target exists, if so return
    _cpp_is_target(_cfp_exists "${_cfp_name}")
    if(_cfp_exists)
        return()
    endif()

    get_directory_property(
        _cfp_old_targets
        DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        BUILDSYSTEM_TARGETS
    )

    #Being blunt we only want to use modules if the user provides them since
    #CMake's versions suck...
    string(TOLOWER ${_cfp_name} _cfp_lc_name)
    _cpp_exists(_cfp_has_recipe "${_cfp_path}/Find${_cfp_name}.cmake")
    if(_cfp_has_recipe)
        list(APPEND CMAKE_MODULE_PATH "${_cfp_path}")
        _cpp_find_from_module(${_cfp_name} "${_cfp_version}" "${_cfp_comps}")
    else()
        _cpp_find_from_config(
            ${_cfp_name} "${_cfp_version}" "${_cfp_comps}" "${_cfp_path}"
        )
    endif()

    if(NOT ${_cfp_name}_FOUND)
        set(${_cfp_found} FALSE PARENT_SCOPE)
        return()
    endif()

    #Determine if new targets were made
    get_directory_property(
        _cfp_targets
        DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        BUILDSYSTEM_TARGETS
    )
    list(APPEND _cfp_targets ${_cfp_old_targets})
    list(LENGTH _cfp_targets _cfp_n)
    if(${_cfp_n} GREATER 0)
        list(REMOVE_DUPLICATES _cfp_targets)
        list(LENGTH _cfp_targets _cfp_n_new)
        if(${_cfp_n_new} GREATER 0)
            _cpp_debug_print("New targets: ${_cfp_targets}")
            return()
        endif()
    endif()

    #Didn't get a target, assume the dependency set the standard CMake variables
    add_library(${_cfp_name} INTERFACE)
    string(TOUPPER ${_cfp_name} _cfp_uc_name)
    string(TOLOWER ${_cfp_name} _cfp_lc_name)
    foreach(_cfp_var ${_cfp_name} ${_cfp_uc_name} ${_cfp_lc_name})
        set(_cfp_include ${_cfp_var}_INCLUDE_DIRS)
        _cpp_is_not_empty(_cfp_has_incs _cfp_include)
        if(_cfp_has_incs)
            target_include_directories(${_cfp_name} INTERFACE ${_cfp_include})
        endif()
        set(_cfp_lib ${_cfp_var}_LIBRARIES)
        _cpp_is_not_empty(_cfp_has_libs _cfp_lib)
        if(_cfp_has_libs)
            target_link_libraries(${_cfp_name} INTERFACE ${_cfp_lib})
        endif()
    endforeach()
endfunction()
