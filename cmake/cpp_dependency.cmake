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

function(_cpp_record_find _crf_cmd)
    set(_crf_O_kwargs NAME VERSION URL SOURCE_DIR)
    set(_crf_M_kwargs COMPONENTS CMAKE_ARGS VIRTUAL)
    cpp_parse_arguments(
        _crf "${ARGN}"
        TOGGLES OPTIONAL
        OPTIONS ${_crf_O_kwargs}
        LISTS ${_crf_M_kwargs}
        MUST_SET NAME
    )
    set(_crf_command "${_crf_cmd}(\n")
    if(_crf_OPTIONAL)
        set(_crf_command "${_crf_command}    OPTIONAL\n")
    endif()
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
    add_library(_cpp_${_crf_NAME}_External INTERFACE)
    set_target_properties(
        _cpp_${_crf_NAME}_External
        PROPERTIES INTERFACE_VERSION "${_crf_command}"
    )
endfunction()

function(_cpp_special_find _csf_was_found _csf_name _csf_version _csf_comps)
    string(TOUPPER "${_csf_name}" _csf_uc_name)
    string(TOLOWER "${_csf_name}" _csf_lc_name)
    set(${_csf_was_found} FALSE)
    foreach(_csf_case ${_csf_name} ${_csf_uc_name} ${_csf_lc_name})
        foreach(_csf_suffix _DIR _ROOT)
            set(_csf_var ${_csf_case}${_csf_suffix})
            #Did the user set this variable
            _cpp_is_not_empty(_csf_set ${_csf_var})
            if(_csf_set)
                _cpp_debug_print(
                   "Looking for ${_csf_name} with ${_csf_var}=${${_csf_var}}"
                )
                _cpp_find_package(
                    _csf_found
                    ${_csf_name}
                    "${_csf_version}"
                    "${_csf_comps}"
                    ${${_csf_var}}
                )
                if(NOT _csf_found)
                    _cpp_error(
                       "${_csf_var} set, but ${_csf_name} not found there"
                       "Troubleshooting:"
                       "  Is ${_csf_name} installed to ${${_csf_var}}?"
                    )
                endif()
                set(${_csf_was_found} TRUE)
                break()
            endif()
        endforeach()
        if(${_csf_was_found})
            break()
        endif()
    endforeach()
    set(${_csf_was_found} ${${_csf_was_found}} PARENT_SCOPE)
endfunction()


function(cpp_find_dependency)
    cpp_parse_arguments(
        _cfd "${ARGN}"
        TOGGLES OPTIONAL
        OPTIONS NAME VERSION RESULT
        LISTS COMPONENTS
        MUST_SET NAME
    )
    cpp_option(_cfd_RESULT CPP_DEV_NULL)
    set(${_cfd_RESULT} TRUE PARENT_SCOPE)

    #If dummy target exists we already found this dependency
    if(TARGET _cpp_${_cfd_NAME}_External)
        return()
    endif()

    #Honor special variables
    _cpp_special_find(
       _cfd_found ${_cfd_NAME} "${_cfd_VERSION}" "${_cfd_COMPONENTS}"
    )

    if(NOT ${_cfd_found})
        #Try a generic search (only honors CMAKE_PREFIX_PATH)
        _cpp_find_package(
            _cfd_found ${_cfd_NAME} "${_cfd_VERSION}" "${_cfd_COMPONENTS}" ""
        )
    endif()

    if(${_cfd_found} OR ${_cfd_OPTIONAL})
        _cpp_record_find("cpp_find_dependency" ${ARGN})
        return()
    endif()

    _cpp_error(
        "Could not locate ${_cfd_NAME}"
        "Troubleshooting: Is the path to ${_cfd_NAME} in CMAKE_PREFIX_PATH?"
        "   (current value of CMAKE_PREFIX_PATH is: ${CMAKE_PREFIX_PATH})"
    )

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

    set(_cfobd_root ${_cfobd_CPP_CACHE}/${_cfobd_NAME})
    if(_cfobd_VERSION)
        set(_cfobd_root "${_cfobd_root}/${_cfobd_VERSION}")
    else()
        set(_cfobd_root "${_cfobd_root}/latest")
    endif()

    #If dummy target exists we already found this dependency
    if(TARGET _cpp_${_cfobd_NAME}_External)
        return()
    endif()

    _cpp_record_find(cpp_find_or_build_dependency ${ARGN})

    #Honor special variables
    _cpp_special_find(
        _cfobd_found ${_cfobd_NAME} "${_cfobd_VERSION}" "${_cfobd_COMPONETS}"
    )

    if(${_cfobd_found})
        return()
    endif()


    #Use get recipe to get source
    _cpp_get_recipe_dispatch(
        ${_cfobd_root}
        NAME ${_cfobd_NAME}
        VERSION ${_cfobd_VERSION}
        ${_cfobd_UNPARSED_ARGUMENTS}
    )
    set(_cfobd_get_recipe ${_cfobd_root}/get-${_cfobd_NAME}.cmake)
    set(_cfobd_get_tar ${_cfobd_root}/${_cfobd_NAME}.tar.gz)
    include(${_cfobd_get_recipe})
    file(SHA1 ${_cfobd_get_tar} _cfobd_src_hash)

    set(
        _cfobd_src_path
        ${_cfobd_CPP_CACHE}/${_cfobd_NAME}/${_cfobd_src_hash}
    )

    set(_cfobd_toolchain ${_cfobd_src_path}/toolchain.cmake)
    file(READ ${_cfobd_TOOLCHAIN} _cfobd_contents)
    file(WRITE ${_cfobd_toolchain} "${_cfobd_contents}")
    _cpp_change_toolchain(
            TOOLCHAIN ${_cfobd_toolchain}
            CMAKE_ARGS "${_cfobd_CMAKE_ARGS}"
    )
    file(SHA1 ${_cfobd_toolchain} _cfobd_tc_hash)
    set(_cfobd_install_path ${_cfobd_src_path}/${_cfobd_tc_hash})

    #Look for package using computed dir
    _cpp_find_package(
       _cfobd_found
       ${_cfobd_NAME}
       "${_cfobd_VERSION}"
       "${_cfobd_COMPONENTS}"
       ${_cfobd_install_path}
    )

    if(${_cfobd_found})
        return()
    endif()

    _cpp_untar_directory(${_cfobd_get_tar} ${_cfobd_src_path})
    if(_cfobd_BUILD_RECIPE)
        include(${_cfobd_BUILD_RECIPE})
    else()
        set(
            _cfobd_build_recipe
            ${_cfobd_install_path}/build-${_cfobd_NAME}.cmake
        )
        _cpp_build_recipe_dispatch(
            ${_cfobd_build_recipe}
            SOURCE_DIR ${_cfobd_src_path}
            INSTALL_DIR ${_cfobd_install_path}
            TOOLCHAIN ${_cfobd_toolchain}
        )
        include(${_cfobd_build_recipe})
    endif()

    #Look again, (find-recipe better be valid now)
    _cpp_find_package(
        _cfobd_found
        ${_cfobd_NAME}
        "${_cfobd_VERSION}"
        "${_cfobd_COMPONENTS}"
        ${_cfobd_install_path}
    )

endfunction()

