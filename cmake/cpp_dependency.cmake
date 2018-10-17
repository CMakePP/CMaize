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
    set(_cdip_O_KWARGS PROJECT_NAME TOOLCHAIN_FILE CPP_CACHE)
    cmake_parse_arguments(_cdip "" "${_cdip_O_KWARGS}" "" "${ARGN}")
    cpp_option(_cdip_PROJECT_NAME ${PROJECT_NAME})
    cpp_option(_cdip_TOOLCHAIN_FILE ${CMAKE_TOOLCHAIN_FILE})
    cpp_option(_cdip_CPP_CACHE ${CPP_INSTALL_CACHE})
    file(SHA1 ${_cdip_TOOLCHAIN_FILE} _cdip_tool_hash)
    set(_cdip_prefix ${_cdip_CPP_CACHE}/${_cdip_name}/${_cdip_PROJECT_NAME})
    set(
        ${_cdip_return}
        ${_cdip_prefix}/${_cdip_tool_hash}
        PARENT_SCOPE
    )
endfunction()

function(_cpp_build_dependency _cbd_name _cbd_recipe)
    set(
        _cbd_${_cbd_name}_root
        ${CMAKE_BINARY_DIR}/external/${_cbd_name}
    )
    _cpp_depend_install_path(_cbd_${_cbd_name}_install ${_cbd_name})

    _cpp_run_sub_build(
        ${_cbd_${_cbd_name}_root}
        INSTALL_PREFIX ${_cbd_${_cbd_name}_install}
        NAME ${_cbd_name}
        CONTENTS "include(\"${_cbd_recipe}\")"
    )
endfunction()



function(_cpp_find_dependency _cfd_found _cfd_name)
    set(${_cfd_found} TRUE PARENT_SCOPE)
    set(_cfd_O_KWARGS VERSION CPP_CACHE)
    set(_cfd_M_KWARGS COMPONENTS CMAKE_ARGS VIRTUAL)
    cmake_parse_arguments(
       _cfd
       ""
       "${_cfd_O_KWARGS}"
       "${_cfd_M_KWARGS}"
    )
    cpp_option(_cfd_${_cfd_name}_CPP_CACHE ${CPP_INSTALL_CACHE})
    #Did the user set CPP_XXX_ROOT?  If so try to find package
    _cpp_non_empty(_cfd_${_cfd_name}_root_set ${_cfd_name}_ROOT)
    if(_cfd_${_cfd_name}_root_set)
        #Try using ${${PackageName}_DIR}} to find a config file
        find_package(
            ${_cfd_name}
            CONFIG
            QUIET
            PATHS "${${_cfd_name}_ROOT}"
            NO_DEFAULT_PATH
        )
        if(${_cfd_name}_FOUND)
          _cpp_debug_print("Found config file: ${${_cfd_name}_CONFIG}")
          return()
        endif()

        find_package(${_cfd_name} REQUIRED MODULE QUIET)
        return()
    endif()

    #If we had built this dependency for this project already it would be here:
    _cpp_depend_install_path(_cfd_${_cfd_name}_cache ${_cfd_name}
                             CPP_CACHE ${_cfd_${_cfd_name}_CPP_CACHE})
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

    find_package(${_cfd_name} MODULE QUIET)
    if(${_cfd_name}_FOUND)
          return()
    endif()

    set(${_cfd_found} FALSE PARENT_SCOPE)
endfunction()

function(cpp_find_dependency _cfd_name)
    _cpp_find_dependency(_cfd_found ${_cfd_name} ${ARGN})
    if(NOT _cfd_found)
        message(
            FATAL_ERROR
            "Unable to locate suitable version of dependency: ${_cfd_name}"
        )
    endif()
endfunction()

#Factored out purely for testing purposes, this function only intended to be
#called from find_or_build_dependency
function(_cpp_write_recipe _cwr_recipe_path _cwr_name)
    set(_cwr_O_KWARGS URL RECIPE PATH BRANCH)
    set(_cwr_M_KWARGS COMPONENTS CMAKE_ARGS)
    cmake_parse_arguments(
        _cwr
        ""
        "${_cwr_O_KWARGS}"
        "${_cwr_M_KWARGS}"
        ${ARGN}
    )
    foreach(_cwr_var PATH URL BRANCH RECIPE)
        _cpp_non_empty(_cwr_${_cwr_var}_set _cwr_${_cwr_var})
    endforeach()

    if(_cwr_PATH_set AND _cwr_URL_set)
        message(FATAL_ERROR "Please specify either PATH or URL")
    elseif(_cwr_PATH AND _cwr_RECIPE_set)
        message(FATAL_ERROR "Please specify either PATH or RECIPE")
    elseif(_cwr_URL AND _cwr_RECIPE)
        message(FATAL_ERROR "Please specify either URL or RECIPE")
    elseif(_cwr_PATH_set)
        if(_cwr_BRANCH_set)
            message(FATAL_ERROR "BRANCH is not comptable with PATH")
        endif()
        file(
            WRITE ${_cwr_recipe_path}
            "include(cpp_build_recipes)
             cpp_local_cmake(${_cwr_name} ${_cwr_PATH})"
        )
    elseif(_cwr_URL_set)
        _cpp_contains(_cwr_is_github "github" "${_cwr_URL}")
        if(_cwr_is_github AND _cwr_BRANCH_set)
            file(
                WRITE ${_cwr_recipe_path}
                "include(cpp_build_recipes)
                cpp_github_cmake(
                    ${_cwr_name}
                    ${_cwr_URL}
                    BRANCH ${_cwr_BRANCH}
                )"
            )
        elseif(_cwr_is_github)
            file(
                WRITE ${_cwr_recipe_path}
                "include(cpp_build_recipes)
                cpp_github_cmake(${_cwr_name} ${_cwr_URL})"
            )
        else()
            message(
                FATAL_ERROR
                "URLs other than GitHub repos are not supported yet."
            )
        endif()
    else()
        message(FATAL_ERROR "Please specify a build mechanism")
    endif()
endfunction()

function(cpp_find_or_build_dependency _cfobd_name)
    _cpp_find_dependency(_cfobd_${_cfobd_name}_found ${_cfobd_name})
    if(_cfobd_${_cfobd_name}_found)
        return()
    endif()
    cmake_parse_arguments(_cfobd "" "RECIPE" "" ${ARGN})
    _cpp_non_empty(_cfobd_recipe_set _cfobd_RECIPE)
    if(_cfobd_recipe_set)
        set(_cfobd_${_cfobd_name}_recipe ${_cfobd_RECIPE})
    else()
        set(
            _cfobd_${_cfobd_name}_recipe
            ${CMAKE_BINARY_DIR}/build_recipes/build-${_cfobd_name}.cmake
        )
        _cpp_write_recipe(
            ${_cfobd_${_cfobd_name}_recipe}
            ${_cfobd_name}
            ${ARGN}
        )
    endif()
    _cpp_debug_print("Using build recipe: ${_cfobd_${_cfobd_name}_recipe}")
    _cpp_build_dependency(${_cfobd_name} ${_cfobd_${_cfobd_name}_recipe})
    cpp_find_dependency(${_cfobd_name})
endfunction()

