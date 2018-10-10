################################################################################
#                        Copyright 2018 Ryan M. Richard                        #
#       Licensed under the Apache License, Version 2.0 (the "License");        #
#       you may not use this file except in compliance with the License.       #
#                   You may obtain a copy of the License at                    #
#                                                                              #
#                  http://www.apache.org/licenses/LICENSE-2.0                  #
#                                                                              #
#     Unless required by applicable law or agreed to in writing, software      #
#      distributed under the License is distributed on an "AS IS" BASIS,       #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
#     See the License for the specific language governing permissions and      #
#                        limitations under the License.                        #
################################################################################

include(cpp_print) #For _cpp_debug_print
include(cpp_checks) #For _cpp_is_valid
include(cpp_cmake_helpers) #For _cpp_write_top_list/_cpp_run_sub_build

# Developer Note:
#  Be very careful with intermediate variables, it is possible for many of these
#  functions to be called recursively (while trying to find/build other
#  dependencies).  Thus all intermediate variables should contain an additonal
#  level of namespacing, presently we use the dependency's name.

function(_cpp_depend_install_path _cdip_return _cdip_name)
    file(SHA1 ${CMAKE_TOOLCHAIN_FILE} _cdip_tool_hash)
    set(
        ${_cdip_return}
        ${CPP_INSTALL_CACHE}/${_cdip_name}/${_cdip_tool_hash}
        PARENT_SCOPE
    )
endfunction()

function(_cpp_build_dependency _cbd_name)

    cpp_option(_cbd_${_cbd_name}_BUILD_RECIPE_PREFIX ${CPP_BUILD_RECIPES})

    _cpp_debug_print(
       "Searching for ${_cbd_name} build recipe in
       ${_cbd_${_cbd_name}_BUILD_RECIPE_PREFIX}"
    )
    find_file(
        _cbd_${_cbd_name}_recipe
        NAMES Build${_cbd_name}.cmake build-${_cbd_name}.cmake
        PATHS ${_cbd_${_cbd_name}_BUILD_RECIPE_PREFIX}
        NO_DEFAULT_PATH
    )
    _cpp_assert_not_equal(
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
        PATH ${_cbd_${_cbd_name}_root}
        NAME ${_cbd_name}
        CONTENTS "include(\"${_cbd_${_cbd_name}_recipe}\")"
    )

    _cpp_depend_install_path(_cbd_${_cbd_name}_install ${_cbd_name})

    _cpp_run_sub_build(
        ${_cbd_${_cbd_name}_root}
        INSTALL_PREFIX ${_cbd_${_cbd_name}_install}
    )
endfunction()



function(cpp_find_dependency _cfd_found _cfd_name)
    set(${_cfd_found} TRUE PARENT_SCOPE)

    #Did the user set CPP_XXX_ROOT?  If so try to find package
    _cpp_non_empty(_cfd_${_cfd_name}_root_set CPP_${_cfd_name}_ROOT)
    if(_cfd_${_cfd_name}_root_set)
        #Try using ${${PackageName}_DIR}} to find a config file
        find_package(
            ${_cfd_name}
            CONFIG
            QUIET
            PATHS "${CPP_${_cfd_name}_ROOT}"
            NO_DEFAULT_PATH
        )
        if(${_cfd_name}_FOUND)
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
    if(${_cfd_name}_FOUND)
        _cpp_debug_print("Found config file: ${${_cfd_name}_CONFIG}")
        return()
    endif()

    find_package(${_cfd_name} MODULE)
    if(${_cfd_name}_FOUND)
          return()
    endif()

    set(${_cfd_found} FALSE PARENT_SCOPE)
endfunction()

function(cpp_find_or_build_dependency _cfobd_name)
    cpp_find_dependency(_cfobd_${_cfobd_name}_found ${_cfobd_name})
    if(_cfobd_${_cfobd_name}_found)
        return()
    endif()
    _cpp_build_dependency(${_cfobd_name})
    cpp_find_dependency(_cfobd_${_cfobd_name}_found ${_cfobd_name})
    if(_cfobd_${_cfobd_name}_found)
        return()
    endif()
    message(FATAL_ERROR "Could not locate dependency after building it")
endfunction()

