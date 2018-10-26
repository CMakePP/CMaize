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

function(_cpp_depend_install_path _cdip_return)
    set(_cdip_O_KWARGS NAME SOURCE_DIR TOOLCHAIN CPP_CACHE BINARY_DIR)
    cmake_parse_arguments(_cdip "" "${_cdip_O_KWARGS}" "" "${ARGN}")
    _cpp_assert_true(_cdip_NAME _cdip_SOURCE_DIR)
    cpp_option(_cdip_TOOLCHAIN "${CMAKE_TOOLCHAIN_FILE}")
    cpp_option(_cdip_CPP_CACHE "${CPP_INSTALL_CACHE}")
    cpp_option(_cdip_BINARY_DIR "${CMAKE_BINARY_DIR}")
    string(RANDOM _cdip_tar_name)
    set(_cdip_tar_file ${_cdip_BINARY_DIR}/${_cdip_tar_name}.tar)
    execute_process(
        COMMAND ${CMAKE_COMMAND} -E tar "cf" "${_cdip_tar_file}"
                                              "${_cdip_SOURCE_DIR}"
    )
    file(SHA1 ${_cdip_tar_file} _cdip_source_hash)
    file(SHA1 ${_cdip_TOOLCHAIN} _cdip_tool_hash)
    set(
        _cdip_prefix ${_cdip_CPP_CACHE}/${_cdip_NAME}/${_cdip_source_hash}
    )
    set(
        ${_cdip_return}
        ${_cdip_prefix}/${_cdip_tool_hash}
        PARENT_SCOPE
    )
endfunction()

function(_cpp_record_find)
    set(_crf_O_kwargs NAME VERSION)
    set(_crf_M_kwargs COMPONENTS CMAKE_ARGS VIRTUAL)
    cmake_parse_arguments(
        _crf
        ""
        "${_crf_O_kwargs}"
        "${_crf_M_kwargs}"
        "${ARGN}"
    )
    _cpp_assert_true(_crf_NAME)
    set(_crf_command "cpp_find_dependency(\n")
    foreach(_crf_O_kwarg_i ${_crf_O_kwargs})
        _cpp_non_empty(_crf_set _crf_${_crf_O_kwarg_i})
        if(_crf_set)
            set(
              _crf_command
              "${_crf_command}    ${_crf_O_kwarg_i} ${_crf_${_crf_O_kwarg_i}}\n"
            )
        endif()
    endforeach()
    foreach(_crf_M_kwarg_i ${_crf_M_kwargs})
        _cpp_non_empty(_crf_set _crf_${_crf_M_kwarg_i})
        if(_crf_set)
            set(_crf_command "${_crf_command}    ${_crf_M_kwarg_i} ")
            foreach(_crf_value_i ${_crf_${_crf_M_kwarg_i}})
                set(_crf_command "${_crf_command}${_crf_value_i} ")
            endforeach()
            set(_crf_command "${_crf_command}\n")
        endif()
    endforeach()
    set(_crf_command "${_crf_command})")
    add_library(_cpp_${_crf_NAME}_interface INTERFACE)
    set_target_properties(
        _cpp_${_crf_NAME}_interface
        PROPERTIES INTERFACE_VERSION "${_crf_command}"
    )
endfunction()

function(_cpp_configure_build _ccb_install _ccb_source)
    set(_ccb_O_kwargs NAME URL SOURCE_DIR INSTALL_DIR)
    cmake_parse_arguments(_ccb "" "${_ccb_O_kwargs}" "" "${ARGN}")
    _cpp_assert_true(_ccb_NAME)
    _cpp_non_empty(_ccb_url_set _ccb_URL)
    _cpp_non_empty(_ccb_source_set _ccb_SOURCE_DIR)
    if(_ccb_url_set)
        cpp_option(_ccb_SOURCE_DIR ${CMAKE_BINARY_DIR}/external/${_ccb_NAME})

    endif()
    if(_ccb_url_set OR _ccb_source_set)
        _cpp_depend_install_path(
                _ccb_install_path
                NAME ${_ccb_NAME}
                SOURCE_DIR ${_ccb_SOURCE_DIR}
        )
        set(${_ccb_install} ${_ccb_install_path} PARENT_SCOPE)
        set(${_ccb_source} ${_ccb_SOURCE_DIR})
    endif()
endfunction()

function(cpp_find_dependency)
    set(_cfd_T_kwargs REQUIRED)
    set(_cfd_O_kwargs NAME VERSION RESULT)
    set(_cfd_M_kwargs COMPONENTS VIRTUAL PATHS)

    cmake_parse_arguments(
            _cfd
            "${_cfd_T_kwargs}"
            "${_cfd_O_kwargs}"
            "${_cfd_M_kwargs}"
            "${ARGN}"
    )
    _cpp_assert_true(_cfd_NAME)


    if(_cfd_COMPONENTS)
        set(_cfd_components "COMPONENTS" ${_cfd_COMPONENTS})
    endif()
    if(_cfd_REQUIRED)
        set(_cfd_required "REQUIRED")
    endif()

    if(_cfd_RESULT)
        #We'll change this if it's not actually found
        set(${_cfd_RESULT} TRUE PARENT_SCOPE)
    endif()


    if(TARGET _cpp_${_cfd_NAME}_interface)
        #Avoid setting interface target 2x
    elseif()
        _cpp_record_find(${ARGN})
    endif()



    #Did the user set XXX_ROOT?  If so try to find package
    _cpp_non_empty(_cfd_root_set ${_cfd_NAME}_ROOT)
    if(_cfd_root_set)
        find_package(
            ${_cfd_NAME}
            ${_cfd_VERSION}
            CONFIG
            QUIET
            PATHS "${${_cfd_NAME}_ROOT}"
            NO_DEFAULT_PATH
            ${_cfd_components}
        )
        if(${_cfd_NAME}_FOUND)
          _cpp_debug_print("Found config file: ${${_cfd_NAME}_CONFIG}")
          return()
        endif()

        find_package(
            ${_cfd_NAME}
            ${_cfd_VERSION}
            REQUIRED
            MODULE
            QUIET
            ${_cfd_components}
        )
        return()
    endif()

    list(APPEND CMAKE_PREFIX_PATH "${_cfd_PATHS}")
    #Start by hoping that a package is ideal
    find_package(
        ${_cfd_NAME}
        ${_cfd_VERSION}
        CONFIG
#        QUIET
        NO_PACKAGE_ROOT_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_PACKAGE_REGISTRY
        NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
        PATHS ${_cfd_install}
        ${_cfd_components}
    )
    if(${_cfd_NAME}_FOUND)
        _cpp_debug_print("Found config file: ${${_cfd_NAME}_CONFIG}")
        return()
    endif()


    find_package(
        ${_cfd_NAME}
        ${_cfd_VERSION}
        ${_cfd_required}
        MODULE
        QUIET
        ${_cfd_components}
    )

    if(${_cfd_NAME}_FOUND)
        return()
    endif()
    if(_cfd_RESULT)
        set(${_cfd_RESULT} FALSE PARENT_SCOPE)
    endif()
endfunction()

function(_cpp_build_local_dependency)
    set(_cbld_O_kwargs NAME SOURCE_DIR INSTALL_DIR TOOLCHAIN BINARY_DIR)
    cmake_parse_arguments(_cbld "" "${_cbld_O_kwargs}" "" "${ARGN}")
    cpp_option(_cbld_TOOLCHAIN "${CMAKE_TOOLCHAIN_FILE}")
    cpp_option(_cbld_BINARY_DIR "${CMAKE_BINARY_DIR}")
    _cpp_assert_true(_cbld_NAME _cbld_SOURCE_DIR _cbld_INSTALL_DIR)
    _cpp_run_sub_build(
            ${_cbld_BINARY_DIR}/${_cbld_NAME}
            NO_INSTALL
            NAME ${_cbld_NAME}
            OUTPUT _cbld_output
            CONTENTS "include(ExternalProject)
                  ExternalProject_Add(
                      ${_cbld_NAME}_External
                      SOURCE_DIR ${_cbld_SOURCE_DIR}
                      INSTALL_DIR ${_cbld_BINARY_DIR}/install
                      CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${_cbld_INSTALL_DIR}
                                 -DCMAKE_TOOLCHAIN_FILE=${_cbld_TOOLCHAIN})"
    )
endfunction()

function(_cpp_get_gh_url _cggu_return)
    set(_cggu_O_kwargs URL BRANCH TOKEN)
    cmake_parse_arguments(_cggu "" "${_cggu_O_kwargs}" "" "${ARGN}")
    _cpp_assert_true(_cggu_URL)
    cpp_option(_cggu_BRANCH master)

    #This parses the organization and repo out of the string
    set(_cggu_string "github.com/")
    string(REGEX MATCH "github\\.com/([^/]*)/([^/]*)" "" "${_cggu_URL}")
    set(_cggu_org "${CMAKE_MATCH_1}")
    set(_cggu_repo "${CMAKE_MATCH_2}")
    _cpp_debug_print("Organization/User: ${_cggu_org}\nRepo: ${_cggu_repo}")

    #If we have a token set up the token part of the URL
    _cpp_non_empty(_cggu_have_token _cggu_TOKEN)
    if(_cggu_have_token)
        set(_cggu_token "?access_token=${_cggu_TOKEN}")
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
    _cpp_assert_true(_cgrt_URL)

    _cpp_contains(_cgrt_is_gh "github.com/" "${_cgrt_URL}")

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

function(_cpp_untar_directory _cud_tar _cud_destination)
    string(RANDOM _cud_prefix)
    set(_cud_buffer_dir ${_cud_destination}/${_cud_prefix})
    execute_process(
            COMMAND ${CMAKE_COMMAND} -E tar "xzf" "${_cud_tar}"
            WORKING_DIRECTORY ${_cud_buffer_dir}
    )

    #We're expecting a single directory
    file(GLOB _cud_tar_files "${_cud_buffer_dir}")
    list(LENGTH _cud_tar_files _cud_nfiles)

    if(_cud_nfiles LESS 1)
        message(FATAL_ERROR "The tarball was empty")
    elseif(_cud_nfiles GREATER 1)
        message(FATAL_ERROR "The tarball contained more than 1 thing.")
    endif()

    list(GET _cud_tar_files 0 _cud_dir)
    file(GLOB _cud_files "${_cud_dir}/*")
    foreach(_cud_file_i ${_cud_files})
        get_filename_component(_cud_file_j ${_cud_file_i} NAME)
        file(RENAME ${_cid_file_i} ${_cud_destination}/${_cud_file_j})
    endforeach()
    file(REMOVE "${_cud_buffer_dir}")
endfunction()

function(_cpp_build_dependency _cbd_tar _cbd_destination)
    cpp_option(_cbd_BINARY_DIR ${CMAKE_BINARY_DIR}/external/${_cbd_NAME})
    _cpp_untar_directory(${_cbd_tar} ${_cbd_BINARY_DIR})
    _cpp_build_local_dependency(
            NAME ${_cbd_NAME}
            SOURCE_DIR ${_cbd_source}
            INSTALL_DIR ${_cbd_destination}
            ${_cbd_UNPARSED_ARGUMENTS}
    )
endfunction()

function(_cpp_get_cache_path _cgcp_result)

    file(SHA1 ${_cgcp_TARBALL} _cgcp_src_hash)
    file(SHA1 ${_cgcp_TOOLCHAIN} _cgcp_tc_hash)
    set(_cgcp_prefix ${_cgcp_CPP_CACHE}/${_cgcp_NAME}/${_cgcp_src_hash})
    set(_cgcp_return ${_cgcp_prefix}/${_cgcp_tc_hash} PARENT_SCOPE)
endfunction()

function(cpp_find_or_build_dependency)
    find_dependency(_cfbod_NAME RESULT _cfbod_found)
    if(_cfbod_found)
        return()
    endif()

    set(_cfobd_tar_file ${_cfobd_BINARY_DIR}/external/${_cfobd_NAME}.tar.gz)
    _cpp_get_source_tarball(_cfobd_tar_file "${ARGN}")
    _cpp_get_cache_path(
            _cfobd_dest
            NAME ${_cfobd_NAME}
            TARBALL ${_cfobd_tar_file}
            TOOLCHAIN ${_cfobd_TOOLCHAIN}
            CPP_CACHE ${_cfobd_CPP_CACHE}

    )
    _cpp_build_dependency(_cfobd_tar_file _cfobd_dest)
    #Append to target Root

    #Set root
    find_dependency(_cfobd_NAME REQUIRED)
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
        if(_cwr_is_github)
            file(
                WRITE ${_cwr_recipe_path}
                "include(cpp_build_recipes)
                cpp_github_cmake(
                    ${_cwr_name}
                    ${_cwr_URL}
                    \"${ARGN}\"
                    TOKEN \"${CPP_GITHUB_TOKEN}\"
                )"
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

