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

function(_cpp_record_find)
    set(_crf_O_kwargs NAME VERSION)
    set(_crf_M_kwargs COMPONENTS CMAKE_ARGS VIRTUAL)
    cpp_parse_arguments(
        _crf "${ARGN}"
        OPTIONS ${_crf_O_kwargs}
        LISTS ${_crf_M_kwargs}
        MUST_SET NAME
    )
    set(_crf_command "cpp_find_dependency(\n")
    foreach(_crf_O_kwarg_i ${_crf_O_kwargs})
        _cpp_is_not_empty(_crf_set _crf_${_crf_O_kwarg_i})
        if(_crf_set)
            set(
              _crf_command
              "${_crf_command}    ${_crf_O_kwarg_i} ${_crf_${_crf_O_kwarg_i}}\n"
            )
        endif()
    endforeach()
    foreach(_crf_M_kwarg_i ${_crf_M_kwargs})
        _cpp_is_not_empty(_crf_set _crf_${_crf_M_kwarg_i})
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

function(_cpp_special_find)
    #Did the user set XXX_ROOT?  If so try to find package
    _cpp_is_not_empty(_cfd_root_set ${_cfd_NAME}_ROOT)
    if(_cfd_root_set)
        _cpp_debug_print("Using ${_cfd_NAME}_ROOT: ${${_cfd_NAME}_ROOT}")
        cmake_policy(SET CMP0074 NEW)
        find_package(
                ${_cfd_NAME}
                ${_cfd_VERSION}
                CONFIG
                ${_cfd_quiet}
                PATHS "${${_cfd_NAME}_ROOT}"
                NO_DEFAULT_PATH
                ${_cfd_components}
        )
        if(${_cfd_NAME}_FOUND)
            _cpp_debug_print("Found config file: ${${_cfd_NAME}_CONFIG}")
        else()
            find_package(
                    ${_cfd_NAME}
                    ${_cfd_VERSION}
                    REQUIRED
                    MODULE
                    ${_cfd_quiet}
                    ${_cfd_components}
            )
        endif()
        #Root was obviously good
        _cpp_update_find_cmd(${_cfd_NAME} ${${_cfd_NAME}_ROOT})
        return()
    endif()
endfunction()


function(cpp_find_dependency)
    message("${ARGN}")
    set(_cfd_original_targets ${BUILDSYSTEM_TARGETS})
    cpp_parse_arguments(
        _cfd "${ARGN}"
        TOGGLES OPTIONAL
        OPTIONS NAME VERSION RESULT
        LISTS COMPONENTS PATHS
        REQUIRED NAME
    )
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
    else()
        _cpp_record_find(${ARGN})
    endif()

    #set(_cfd_quiet QUIET)
    _cpp_special_find()

    #call find recipe

    message("CFD: ${CMAKE_PREFIX_PATH} ${_cfd_PATHS}")
    list(APPEND CMAKE_PREFIX_PATH ${_cfd_PATHS})
    #Start by hoping that a package is ideal
    find_package(
        ${_cfd_NAME}
        ${_cfd_VERSION}
        CONFIG
        ${_cfd_quiet}
#        NO_PACKAGE_ROOT_PATH
        NO_DEFAULT_PATH
#        NO_SYSTEM_ENVIRONMENT_PATH
#        NO_CMAKE_PACKAGE_REGISTRY
#        NO_CMAKE_SYSTEM_PACKAGE_REGISTRY
        PATHS ${_cfd_PATHS}
        ${_cfd_components}
    )
    if(${_cfd_NAME}_FOUND)
        _cpp_debug_print("Found config file: ${${_cfd_NAME}_CONFIG}")
        get_filename_component(
                _cfd_install_path
                ${${_cfd_NAME}_CONFIG}
                DIRECTORY
        )
        _cpp_update_find_cmd(${_cfd_NAME} ${_cfd_install_path})
        return()
    endif()

    find_package(
        ${_cfd_NAME}
        ${_cfd_VERSION}
        ${_cfd_required}
        MODULE
        ${_cfd_quiet}
        ${_cfd_components}
    )

    if(${_cfd_NAME}_FOUND)
        _cpp_update_find_cmd(${_cfd_NAME} "${_cfd_PATHS}")
        return()
    endif()
    if(_cfd_RESULT)
        set(${_cfd_RESULT} FALSE PARENT_SCOPE)
    endif()
endfunction()

function(_cpp_get_gh_url _cggu_return)
    set(_cggu_T_kwargs PRIVATE)
    set(_cggu_O_kwargs URL BRANCH)
    cmake_parse_arguments(
        _cggu
        "${_cggu_T_kwargs}"
        "${_cggu_O_kwargs}"
        ""
        "${ARGN}"
    )
    _cpp_assert_true(_cggu_URL)
    cpp_option(_cggu_BRANCH master)
    _cpp_assert_contains("github.com" "${_cggu_URL}")

    #This parses the organization and repo out of the string
    set(_cggu_string "github.com/")
    string(REGEX MATCH "github\\.com/([^/]*)/([^/]*)" "" "${_cggu_URL}")
    set(_cggu_org "${CMAKE_MATCH_1}")
    set(_cggu_repo "${CMAKE_MATCH_2}")
    _cpp_debug_print("Organization/User: ${_cggu_org} Repo: ${_cggu_repo}")

    if(_cggu_PRIVATE)
        _cpp_is_not_empty(_cggu_token_set CPP_GITHUB_TOKEN)
        if(NOT _cggu_token_set)
            message(
                FATAL_ERROR
                "For private repos CPP_GITHUB_TOKEN must be a valid token."
            )
        endif()
        set(_cggu_token "?access_token=${CPP_GITHUB_TOKEN}")
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
    if(_cgrt_URL)
        _cpp_debug_print("Getting source from URL: ${_cgrt_URL}")
    endif()
    if(_cgrt_SOURCE_DIR)
        _cpp_debug_print("Getting source from dir: ${_cgrt_SOURCE_DIR}")
    endif()
    _cpp_xor(_cgrt_one_set _cgrt_URL _cgrt_SOURCE_DIR)
    if(NOT _cgrt_one_set)
        message(FATAL_ERROR "Please specify either URL or SOURCE_DIR")
    endif()

    _cpp_contains(_cgrt_is_gh "github.com/" "${_cgrt_URL}")

    if(_cgrt_SOURCE_DIR)
        #User gave us /a/long/path/to/here and we want the tarball to untar to
        #just here
        get_filename_component(_cgrt_work_dir "${_cgrt_SOURCE_DIR}" DIRECTORY)
        get_filename_component(_cgrt_dir "${_cgrt_SOURCE_DIR}" NAME)
        execute_process(
            COMMAND ${CMAKE_COMMAND} -E tar "cfz" "${_cgrt_file}" "${_cgrt_dir}"
            WORKING_DIRECTORY ${_cgrt_work_dir}
        )
        return()
    endif()

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
    _cpp_assert_exists(${_cud_tar})
    string(RANDOM _cud_prefix)
    set(_cud_buffer_dir ${_cud_destination}/${_cud_prefix})
    file(MAKE_DIRECTORY ${_cud_buffer_dir})
    execute_process(
            COMMAND ${CMAKE_COMMAND} -E tar "xzf" "${_cud_tar}"
            WORKING_DIRECTORY ${_cud_buffer_dir}
    )

    #We're expecting a single directory
    file(GLOB _cud_tar_files "${_cud_buffer_dir}/*")
    list(LENGTH _cud_tar_files _cud_nfiles)
    _cpp_debug_print(
        "Tarball contained ${_cud_nfiles} files: ${_cud_tar_files}."
    )

    if(_cud_nfiles LESS 1)
        message(FATAL_ERROR "The tarball was empty")
    elseif(_cud_nfiles GREATER 1)
        message(FATAL_ERROR "The tarball contained more than 1 thing.")
    endif()

    list(GET _cud_tar_files 0 _cud_dir)
    if(IS_DIRECTORY "${_cud_dir}")
        file(GLOB _cud_files "${_cud_dir}/*")
        foreach(_cud_file_i ${_cud_files})
            get_filename_component(_cud_file_j ${_cud_file_i} NAME)
            file(RENAME ${_cud_file_i} ${_cud_destination}/${_cud_file_j})
        endforeach()
        file(REMOVE "${_cud_buffer_dir}")
    else()
        message(FATAL_ERROR "The tarball does not contain a directory.")
    endif()
endfunction()


function(_cpp_build_local_dependency)
    set(_cbld_O_kwargs NAME SOURCE_DIR INSTALL_DIR TOOLCHAIN BINARY_DIR)
    set(_cbld_M_kwargs CMAKE_ARGS)
    cmake_parse_arguments(
        _cbld
        ""
        "${_cbld_O_kwargs}"
        "${_cbld_M_kwargs}"
        "${ARGN}"
    )
    cpp_option(_cbld_TOOLCHAIN "${CMAKE_TOOLCHAIN_FILE}")
    cpp_option(_cbld_BINARY_DIR "${CMAKE_BINARY_DIR}/${_cbld_NAME}")
    _cpp_assert_true(_cbld_NAME _cbld_SOURCE_DIR _cbld_INSTALL_DIR)

    #Can't rely on the toolchain b/c CMake's option command overrides it...
    set(_cbld_cmake_args "-DCMAKE_INSTALL_PREFIX=${_cbld_INSTALL_DIR}\n")
    set(
        _cbld_cmake_args
        "${_cbld_cmake_args}-DCMAKE_TOOLCHAIN_FILE=${_cbld_TOOLCHAIN}\n"
    )
    foreach(_cbld_arg_i ${_cbld_CMAKE_ARGS})
        set(
            _cbld_cmake_args
            "${_cbld_cmake_args}-D${_cbld_arg_i}\n"
        )
    endforeach()

    _cpp_run_sub_build(
            ${_cbld_BINARY_DIR}
            NAME ${_cbld_NAME}
            OUTPUT _cbld_output
            NO_INSTALL
            TOOLCHAIN ${_cbld_TOOLCHAIN}
            CONTENTS "include(ExternalProject)"
                     "ExternalProject_Add("
                     "  ${_cbld_NAME}_External"
                     "  SOURCE_DIR ${_cbld_SOURCE_DIR}"
                     "  INSTALL_DIR ${_cbld_BINARY_DIR}/install"
                     "  CMAKE_ARGS ${_cbld_cmake_args}"
                     ")"
    )
    _cpp_debug_print("${_cbld_output}")
endfunction()

function(_cpp_update_find_cmd _cufc_name _cufc_path)
    get_target_property(
            _cufc_command
            _cpp_${_cufc_name}_interface
            INTERFACE_VERSION
    )
    _cpp_contains(_cufc_path_set "PATHS" "${_cufc_command}")
    if(_cufc_path_set)
        return() #Avoid setting it twice
    endif()
    string(
        REGEX REPLACE "\\)" " PATHS ${_cufc_path})"
        _cufc_command
        "${_cufc_command}"
    )
    set_target_properties(
         _cpp_${_cufc_name}_interface
         PROPERTIES INTERFACE_VERSION "${_cufc_command}"
    )
endfunction()

function(cpp_find_or_build_dependency)
    #If dummy target exists we already found this dependency
    if(TARGET _cpp_${_cfobd_NAME}_External)
        return()
    endif()
    cpp_parse_arguments(
        _cfobd "${ARGN}"
        TOGGLES PRIVATE
        OPTIONS NAME BINARY_DIR BRANCH URL SOURCE_DIR CPP_CACHE
        LISTS CMAKE_ARGS
        REQUIRED NAME
    )
    cpp_option(_cfobd_BINARY_DIR "${CMAKE_BINARY_DIR}")
    cpp_option(_cfobd_CPP_CACHE "${CPP_INSTALL_CACHE}")

    #Look for dependency before we build it
    cpp_find_dependency(NAME ${_cfobd_NAME} RESULT _cfobd_found)
    if(_cfobd_found)
        return()
    endif()

    #Didn't find it so now we build it
    set(_cfobd_root ${_cfobd_BINARY_DIR}/external/${_cfobd_NAME})
    file(MAKE_DIRECTORY ${_cfobd_root})

    #Get the source
    set(_cfobd_tar_file ${_cfobd_root}/${_cfobd_NAME}.tar.gz)
    _cpp_get_source_tarball(${_cfobd_tar_file} ${ARGN})

    #Make the new toolchain by copying old and appending CMAKE_ARGS
    set(_cfobd_toolchain ${_cfobd_root}/toolchain.cmake)
    file(READ ${CMAKE_TOOLCHAIN_FILE} _cfobd_contents)
    file(WRITE ${_cfobd_toolchain} "${_cfobd_contents}")
    _cpp_change_toolchain(
        TOOLCHAIN ${_cfobd_toolchain}
        CMAKE_ARGS "${_cfobd_CMAKE_ARGS}"
    )

    #Build from source
    file(SHA1 ${_cfobd_tar_file} _cfobd_src_hash)
    set(
        _cfobd_source_path
        ${_cfobd_CPP_CACHE}/${_cfobd_NAME}/${_cfobd_src_hash}
    )
    file(SHA1 ${_cfobd_toolchain} _cfobd_tc_hash)
    set(_cfobd_install_path ${_cfobd_source_path}/${_cfobd_tc_hash})
    message("CFOBD: ${_cfobd_install_path}")
    #Now that we know the install path try to find it one more time in case CPP
    #already built it
    cpp_find_dependency(
        NAME ${_cfobd_NAME}
        PATHS "${_cfobd_install_path}"
        RESULT _cfobd_found
    )
    if(_cfobd_found)
        _cpp_debug_print("Using cached version at: ${_cfobd_install_path}")
        return()
    endif()

    if(EXISTS ${_cfobd_source_path}/source)
    else()
        _cpp_untar_directory(${_cfobd_tar_file} ${_cfobd_source_path}/source)
    endif()

    _cpp_build_local_dependency(
         NAME ${_cfobd_NAME}_Build
         BINARY_DIR ${_cfobd_root}/CMakeFiles
         SOURCE_DIR ${_cfobd_source_path}/source
         TOOLCHAIN ${_cfobd_toolchain}
         INSTALL_DIR ${_cfobd_install_path}
         CMAKE_ARGS ${_cfobd_CMAKE_ARGS}
    )

    #Find it so variables/targets are in scope
    cpp_find_dependency(
       NAME  ${_cfobd_NAME}
       PATHS ${_cfobd_install_path}
       REQUIRED
    )

endfunction()
