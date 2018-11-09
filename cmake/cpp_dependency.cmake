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

function(_cpp_special_find _csf_name _csf_version _csf_comps)
    string(TOUPPER "${_csf_name}" _csf_uc_name)
    string(TOLOWER "${_csf_name}" _csf_lc_name)
    foreach(_csf_case ${_csf_name} ${_csf_uc_name} ${_csf_lc_name})
        foreach(_csf_suffix _DIR _ROOT)
            set(_csf_var ${_csf_case}_${_csf_suffix})
            #Did the user set this variable
            _cpp_is_not_empty(_csf_set ${_csf_var})
            if(_csf_set)
                _cpp_debug_print(
                   "Looking for ${_csf_name} with ${_csf_var}=${${_csf_var}}"
                )
                _cpp_generic_find_search(
                    _csf_found
                    ${_csf_name}
                    "${_csf_version}"
                    "${_csf_comps}"
                    ${${_csf_var}}
                )
                if(NOT _csf_found)
                    message(
                        FATAL_ERROR
                        "${_csf_var} set, but ${_csf_name} not found there"
                    )
                endif()
            endif()
        endforeach()
    endforeach()
endfunction()


function(cpp_find_dependency)
    cpp_parse_arguments(
        _cfd "${ARGN}"
        TOGGLES OPTIONAL
        OPTIONS NAME VERSION RESULT
        LISTS COMPONENTS
        REQUIRED NAME
    )
    cpp_option(_cfd_RESULT CPP_DEV_NULL)
    if(_cfd_COMPONENTS)
        set(_cfd_components "COMPONENTS" ${_cfd_COMPONENTS})
    endif()
    set(${_cfd_RESULT} TRUE PARENT_SCOPE)

    #Honor special variables
    _cpp_special_find(${_cfd_NAME} "${_cfd_VERSION}" "${_cfd_COMPONENTS}")

    #Try a generic search (only honors CMAKE_PREFIX_PATH
    _cpp_generic_find_search(
        _cfd_found ${_cfd_NAME} "${_cfd_VERSION}" "${_cfd_COMPONENTS}" ""
    )

    if(_cfd_OPTIONAL)
        #Write find command to target
        return()
    endif()

    message(FATAL_ERROR "Could not locate ${_cfd_NAME}")

endfunction()

function(cpp_find_or_build_dependency)
    cpp_parse_arguments(
        _cfobd "${ARGN}"
        OPTIONS NAME GET_RECIPE FIND_RECIPE BUILD_RECIPE TOOLCHAIN VERSION
        LISTS COMPONENTS CMAKE_ARGS
        MUST_SET NAME
    )
    cpp_option(_cfobd_TOOLCHAIN ${CMAKE_TOOLCHAIN_FILE})
    cpp_option(_cfobd_BINARY_DIR "${CMAKE_BINARY_DIR}")
    cpp_option(_cfobd_CPP_CACHE "${CPP_INSTALL_CACHE}")


    set(_cfobd_root ${_cfobd_CPP_CACHE}/${_cfobd_NAME}/${_cfobd_VERSION})

    #If dummy target exists we already found this dependency
    if(TARGET _cpp_${_cfobd_NAME}_External)
        return()
    endif()

    #Honor special variables
    _cpp_special_find(${_cfobd_NAME} "${_cfobd_VERSION}" "${_cfobd_COMPONETS}")

    #Use get recipe to get source
    _cpp_get_recipe_dispatch(
        _cfobd_get_dir
        NAME ${_cfobd_NAME}
        VERSION ${_cfobd_VERSION}
        ${_cfobd_UNPARSED_ARGUMENTS}
    )
    set(_cfobd_get_recipe ${_cfobd_get_dir}/get-${_cfobd_NAME}.cmake)
    set(_cfobd_get_tar ${_cfobd_get_dir}/${_cfobd_NAME}.cmake)
    include(${_cfobd_get_recipe})
    file(SHA1 ${_cfobd_get_tar} _cfobd_src_hash)

    set(
        _cfobd_install_path
        ${_cfobd_CPP_CACHE}/${_cfobd_NAME}/${_cfobd_src_hash}
    )
    set(_cfobd_toolchain ${_cfobd_install_path}/toolchain.cmake)
    file(READ ${_cfobd_TOOLCHAIN} _cfobd_contents)
    file(WRITE ${_cfobd_toolchain} "${_cfobd_contents}")
    _cpp_change_toolchain(
            TOOLCHAIN ${_cfobd_toolchain}
            CMAKE_ARGS "${_cfobd_CMAKE_ARGS}"
    )
    file(SHA1 ${_cfobd_toolchain} _cfobd_tc_hash)
    set(_cfobd_install_path "${_cfobd_install_path}/${_cfobd_tc_hash}")


    #Look for package using computed dir
    _cpp_generic_find_search(
       _cfobd_found
       ${_cfobd_NAME}
       "${_cfobd_VERSION}"
       "${_cfobd_COMPONENTS}"
       ${_cfobd_install_path}
    )

    if(NOT _cfobd_found)
        _cpp_build_recipe_dispatch(_cfobd_build_recipe)
    endif()


    #Look again, (find-recipe better be valid now)
    _cpp_generic_find_search(
        _cfobd_found
        ${_cfobd_NAME}
        "${_cfobd_VERSION}"
        "${_cfobd_COMPONENTS}"
        ${_cfobd_install_path}
    )

    if(NOT _cfobd_found)
        message(FATAL_ERROR "Could not find built ${_cfobd_NAME}")
    endif()


    #Didn't find it so now we build it
    set(_cfobd_root ${_cfobd_BINARY_DIR}/external/${_cfobd_NAME})
    file(MAKE_DIRECTORY ${_cfobd_root})

    #Get the source
    set(_cfobd_tar_file ${_cfobd_root}/${_cfobd_NAME}.tar.gz)
    _cpp_get_source_tarball(${_cfobd_tar_file} ${ARGN})



    #Build from source

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

