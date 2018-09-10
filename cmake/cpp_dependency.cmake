include(cpp_print) #For _cpp_debug_print
include(cpp_checks) #For _cpp_is_valid
include(cpp_cmake_helpers) #For _cpp_write_top_list/_cpp_run_sub_build

function(_cpp_depend_install_path _cdip_return _cdip_name)
    file(SHA1 ${CMAKE_TOOLCHAIN_FILE} _cdip_tool_hash)
    set(
        ${_cdip_return}
        ${CPP_LOCAL_CACHE}/${PROJECT_NAME}/${_cdip_tool_hash}/${_cdip_name}
        PARENT_SCOPE
    )
endfunction()

function(_cpp_build_dependency _cbd_name)
    find_file(
        _cbd_${_cbd_name}_recipe
        NAMES Build${_cbd_name}.cmake build-${_cbd_name}.cmake
        PATHS ${CPP_BUILD_RECIPES}
        NO_DEFAULT_PATH
    )
    _cpp_assert_str_not_equal(
       "${_cbd_${_cbd_name}_recipe}"
       "_cbd_${_cbd_name}_recipe-NOTFOUND"

    )
    _cpp_debug_print(
        "Building ${_cbd_name} with recipe: ${_cbd_${_cbd_name}_recipe}"
    )

    set(
        _cbd_${_cbd_name}_root
        ${CMAKE_BINARY_DIR}/external/${_cbd_name}
    )

    _cpp_write_top_list(
        ${_cbd_${_cbd_name}_root}/CMakeLists.txt
        ${_cbd_name}
        "include(\"${_cbd_${_cbd_name}_recipe}\")"
    )

    _cpp_depend_install_path(_cbd_${_cbd_name}_install ${_cbd_name})

    _cpp_run_sub_build(
        ${_cbd_${_cbd_name}_root}
        INSTALL_PREFIX ${_cbd_${_cbd_name}_install}
        NO_INSTALL
    )
endfunction()



function(cpp_find_dependency _cfd_found _cfd_name)
    #Note this function may be called recursively from a dependency so all
    #variables require an additional level of namespace protection related to
    #the dependency

    #Did the user set XXX_ROOT?
    _cpp_valid(_cfd_${_cfd_name}_root_set ${_cfd_name}_ROOT)
    if(_cfd_${_cfd_name}_root_set)
        #Try using ${${PackageName}_ROOT}} to find a config file
        find_package(
            ${_cfd_name}
            CONFIG
            QUIET
            PATHS ${_cfd_name}
            NO_DEFAULT_PATH
        )
        _cpp_valid(_cfd_${_cfd_name}_config_found ${_cfd_name}_FOUND)
        if(_cfd_${_cfd_name}_config_found)
            _cpp_debug_print("Found config file: ${${_cfd_name}_CONFIG}")
            return()
        endif()
        find_package(${_cfd_name} REQUIRED MODULE)
        return()
    endif()

    #If we had built this dependency for this project already it would be here:
    _cpp_depend_install_path(_cfd_${_cfd_name}_cache ${_cfd_name})
    list(APPEND CMAKE_PREFIX_PATH ${_cfd_${_cfd_name}_cache})

    #Start by hoping that a package is ideal
    find_package(
        ${_cfd_name}
        CONFIG
        QUIET
        NO_PACKAGE_ROOT_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_PACKAGE_REGISTRY
        NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
        PATHS ${_cfd_${_cfd_name}_cache}
    )
    _cpp_valid(_cfd_${_cfd_name}_ideal ${_cfd_name}_FOUND)
    if(_cfd_${_cfd_name}_ideal)
        _cpp_debug_print("Found config file: ${${_cfd_name}_CONFIG}")
        return()
    endif()

    find_package(${_cfd_name} MODULE)
    _cpp_valid(_cfd_${_cfd_name}_found ${_cfd_name}_FOUND)
    if(_cfd_${_cfd_name}_found)
          return()
    endif()

    set(${_cfd_found} FALSE PARENT_SCOPE)
endfunction()

function(cpp_find_or_build_dependency _cfobd_name)
    find_dependency(_cfobd_${_cfobd_name}_found ${_cfobd_name})
    if(_cfobd_${_cfobd_name}_found)
        return()
    endif()
    _cpp_build_dependency(${_cfobd_name})
    find_dependency(_cfobd_${_cfobd_name}_found)
    if(_cfobd_${_cfobd_name}_found)
        return()
    endif()
    message(FATAL_ERROR "Could not locate dependency after building it")
endfunction()

