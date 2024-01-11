# Copyright 2023 CMakePP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_guard()
include(cmakepp_lang/cmakepp_lang)
include(cmaize/targets/targets)
include(cmaize/utilities/glob_files)
include(cmaize/utilities/replace_project_targets)

#[[[
# User function to build a library target.
#
# .. note::
#
#    For additional optional parameters related to the specific language
#    used, see the documentation for `cmaize_add_<LANGUAGE>_library()`,
#    where `<LANGUAGE>` is the language being used. Supported languages
#    are listed in the ``CMAIZE_SUPPORTED_LANGUAGES`` variable.
#
# :param _cal_tgt_name: Name of the target to be created.
# :type _cal_tgt_name: desc
# :param LANGUAGE: Build language for the target, defaults to "CXX"
# :type LANGUAGE: desc, optional
#]]
function(cmaize_add_library _cal_tgt_name)

    message(VERBOSE "Registering library target: ${_cal_tgt_name}")

    set(_cal_one_value_args LANGUAGE)
    cmake_parse_arguments(_cal "" "${_cal_one_value_args}" "" ${ARGN})

    # Default to CXX if no language is given
    if("${_cal_LANGUAGE}" STREQUAL "")
        set(_cal_LANGUAGE "CXX")
    endif()

    # Decide which language we are building for
    string(TOLOWER "${_cal_LANGUAGE}" _cal_LANGUAGE_lower)
    set(_cal_tgt_obj "")
    if("${_cal_LANGUAGE_lower}" STREQUAL "cxx")
        cmaize_add_cxx_library(_cal_tgt_obj
            "${_cal_tgt_name}"
            ${_cal_UNPARSED_ARGUMENTS}
        )
    elseif()
        cpp_raise(
            InvalidBuildLanguage
            "Invalid build language: ${_cal_LANGUAGE}"
        )
    endif()

    cpp_get_global(_cal_project CMAIZE_TOP_PROJECT)

    CMaizeProject(add_target
        "${_cal_project}" "${_cal_tgt_name}" "${_cal_tgt_obj}"
    )
    CMaizeProject(add_language "${_cal_project}" "${_cal_LANGUAGE}")

    # Build the install location for this library based on the project name.
    # Note that this is overwritten if cmaize_find_or_build_dependency()
    # is building this target.
    cpp_get_global(_cal_proj CMAIZE_PROJECT_${PROJECT_NAME})
    CMaizeProject(GET "${_cal_proj}" _cal_proj_name name)
    set(
        _cal_install_path
        "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}/${_cal_proj_name}"
    )
    CMaizeTarget(SET "${_cal_tgt_obj}" install_path "${_cal_install_path}")
    CMaizeTarget(SET_PROPERTY
        "${_cal_tgt_obj}"
        INSTALL_PATH "${_cal_install_path}"
    )

    # Loop over each dependency. This is currently done by looking
    # up the dependencies by name from the CMaizeProject, but later
    # we should make each CMaize target hold references to its
    # dependencies
    cpp_get_global(_cal_top_proj CMAIZE_TOP_PROJECT)
    BuildTarget(GET "${_cal_tgt_obj}" _dep_list depends)
    foreach(dependency ${_dep_list})
        # Fetch the dependency's target object
        CMaizeProject(get_target
            "${_cal_top_proj}" _dep_tgt_obj "${dependency}"
        )

        # Skip the dependency if it is not managed by CMaize, since
        # those won't have install path information
        if("${_dep_tgt_obj}" STREQUAL "")
            continue()
        endif()

        # Get the install path for the dependency
        CMaizeTarget(GET "${_dep_tgt_obj}" _dep_install_path install_path)

        # Turn the dependency paths into absolute paths
        file(REAL_PATH
            "${_cal_destination_prefix}/${CMAKE_INSTALL_LIBDIR}/${_cal_pkg_name}"
            _cal_lib_path
            BASE_DIRECTORY "${CMAKE_INSTALL_PREFIX}"
        )
        # Replace install prefix with $ORIGIN
        # We currently don't do this since we couldn't get it to work
        # string(REPLACE "${_cal_lib_path}" "$ORIGIN" _dep_install_path "${_dep_install_path}")

        # While not a great way to do it, this will check if the dependency
        # has any INSTALL_RPATH data. If it does, we add that data to the
        # current target as well. In theory, each target should manage its
        # own INSTALL_RPATH set, but for now that does not seem to be working.
        CMaizeTarget(has_property "${_dep_tgt_obj}" _dep_has_install_rpath INSTALL_RPATH)
        if(_dep_has_install_rpath)
            CMaizeTarget(get_property "${_dep_tgt_obj}" _dep_install_rpath INSTALL_RPATH)
        endif()

        # Actually append the aggregated paths to the current target's
        # INSTALL_RPATH
        set(_install_rpath "")

        CMaizeTarget(
            has_property "${_cal_tgt_obj}" _has_install_rpath INSTALL_RPATH
        )
        if(_has_install_rpath)
            CMaizeTarget(
                get_property "${_cal_tgt_obj}" _install_rpath INSTALL_RPATH
            )
        endif()
        list(APPEND _install_rpath ${_dep_install_path})
        list(APPEND _install_rpath ${_dep_install_rpath})
        CMaizeTarget(
            set_property "${_cal_tgt_obj}" INSTALL_RPATH "${_install_rpath}"
        )
    endforeach()

endfunction()

#[[[
# User function to build a CXX library target.
#
# .. note::
#
#    See ``CXXTarget(make_target`` documentation for additional optional
#    arguments.
#
# :param _cacl_tgt_obj: Returned target object created.
# :type _cacl_tgt_obj: BuildTarget
# :param _cal_tgt_name: Name of the target to be created.
# :type _cal_tgt_name: desc
# :param SOURCE_DIR: Directory containing source code.
# :type SOURCE_DIR: path, optional
# :param INCLUDE_DIRS: Directories containing files to include.
# :type INCLUDE_DIRS: path, optional
#
# :returns: CXX library target object.
# :rtype: BuildTarget
#]]
function(cmaize_add_cxx_library _cacl_tgt_obj _cacl_tgt_name)
    set(_cacl_one_value_args SOURCE_DIR)
    set(_cacl_multi_value_args INCLUDE_DIRS SOURCE_EXTS INCLUDE_EXTS DEPENDS)

    cmake_parse_arguments(
        _cacl "" "${_cacl_one_value_args}" "${_cacl_multi_value_args}" ${ARGN}
    )

    # Determines if the user gave custom source file extensions, otherwise
    # defaulting to CMAKE_CXX_SOURCE_FILE_EXTENSIONS
    list(LENGTH _cacl_SOURCE_EXTS _cacl_SOURCE_EXTS_n)
    if(NOT "${_cacl_SOURCE_EXTS_n}" GREATER 0)
        set(_cacl_SOURCE_EXTS "${CMAKE_CXX_SOURCE_FILE_EXTENSIONS}")
    endif()

    # Determines if the user gave custom include file extensions, otherwise
    # defaulting to CMAIZE_CXX_INCLUDE_FILE_EXTENSIONS
    list(LENGTH _cacl_INCLUDE_EXTS _cacl_INCLUDE_EXTS_n)
    if(NOT "${_cacl_INCLUDE_EXTS_n}" GREATER 0)
        cpp_get_global(_cacl_INCLUDE_EXTS CMAIZE_CXX_INCLUDE_FILE_EXTENSIONS)
    endif()

    _cmaize_glob_files(_cacl_source_files "${_cacl_SOURCE_DIR}" "${_cacl_SOURCE_EXTS}")
    _cmaize_glob_files(_cacl_include_files "${_cacl_INCLUDE_DIRS}" "${_cacl_INCLUDE_EXTS}")

    # Check if any source files were provided to determine if the target
    # is a library or interface library
    list(LENGTH _cacl_source_files _cacl_source_files_n)
    if("${_cacl_source_files_n}" GREATER 0)
        CXXLibrary(CTOR _cacl_lib_obj "${_cacl_tgt_name}")
    else()
        CXXInterfaceLibrary(CTOR _cacl_lib_obj "${_cacl_tgt_name}")
    endif()

    CXXLibrary(make_target
        "${_cacl_lib_obj}"
        INCLUDES "${_cacl_include_files}"
        INCLUDE_DIRS "${_cacl_INCLUDE_DIRS}"
        SOURCES "${_cacl_source_files}"
        SOURCE_DIR "${_cacl_SOURCE_DIR}"
        DEPENDS "${_cacl_DEPENDS}"
        ${_cacl_UNPARSED_ARGUMENTS}
    )

    set("${_cacl_tgt_obj}" "${_cacl_lib_obj}")

    cpp_return("${_cacl_tgt_obj}")

endfunction()
