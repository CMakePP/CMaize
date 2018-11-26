include_guard()

function(_cpp_find_package _cfp_found _cfp_name _cfp_recipe _cfp_path)

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
    include(${_cfp_recipe})
    _cpp_call_recipe("${_cfp_path}")

    #Assuming the recipe calls find_package, note that in its infinite wisdom
    #CMake will set XXX_DIR to XXX_DIR-NOTFOUND screwing with our special find
    set(_cfp_dir_var ${_cfp_name}_DIR)
    _cpp_are_equal(
        _cfp_dir_notfound "${${_cfp_dir_var}}" "${_cfp_dir_var}-NOTFOUND"
    )
    if(_cfp_dir_notfound)
        unset(${_cfp_dir_var} PARENT_SCOPE)
        unset(${_cfp_dir_var} CACHE)
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
    list(LENGTH _cfp_n_new _cfp_targets)
    list(LENGTH _cfp_n_old _cfp_old_targets)
    _cpp_are_not_equal(_cfp_new_targets "${_cfp_n_new}" "${_cfp_n_old}")
    if(_cfp_new_targets)
        _cpp_debug_print("New targets: ${_cfp_targets}")
        return()
    endif()

    #Didn't get a target, assume the dependency set the standard CMake variables
    add_library(${_cfp_name} INTERFACE)
    string(TOUPPER ${_cfp_name} _cfp_uc_name)
    string(TOLOWER ${_cfp_name} _cfp_lc_name)
    foreach(_cfp_var ${_cfp_name} ${_cfp_uc_name} ${_cfp_lc_name})
        set(_cfp_include ${_cfp_var}_INCLUDE_DIRS)
        _cpp_is_not_empty(_cfp_has_incs ${_cfp_include})
        if(_cfp_has_incs)
            target_include_directories(
                ${_cfp_name} INTERFACE ${${_cfp_include}}
            )
        endif()
        set(_cfp_lib ${_cfp_var}_LIBRARIES)
        _cpp_is_not_empty(_cfp_has_libs ${_cfp_lib})
        if(_cfp_has_libs)
            target_link_libraries(${_cfp_name} INTERFACE ${${_cfp_lib}})
        endif()
    endforeach()
endfunction()
