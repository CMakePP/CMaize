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
include(cmaize/utilities/replace_project_targets)

#[[[
# User function to build a executable target.
#
# .. note::
#
#    For additional optional parameters related to the specific language
#    used, see the documentation for `cmaize_add_<LANGUAGE>_executable()`,
#    where `<LANGUAGE>` is the language being used. Supported languages
#    are listed in the ``CMAIZE_SUPPORTED_LANGUAGES`` variable.
#
# :param _cae_tgt_name: Name of the target to be created.
# :type _cae_tgt_name: desc
# :param LANGUAGE: Build language for the target, defaults to "CXX"
# :type LANGUAGE: desc, optional
#]]
function(cmaize_add_executable _cae_tgt_name)

    message(VERBOSE "Registering executable target: ${_cae_tgt_name}")

    set(_cae_one_value_args LANGUAGE)
    cmake_parse_arguments(_cae "" "${_cae_one_value_args}" "" ${ARGN})

    # Default to CXX if no language is given
    if("${_cae_LANGUAGE}" STREQUAL "")
        set(_cae_LANGUAGE "CXX")
    endif()

    # Decide which language we are building for
    string(TOLOWER "${_cae_LANGUAGE}" _cae_LANGUAGE_lower)
    set(_cae_tgt_obj "")
    if("${_cae_LANGUAGE_lower}" STREQUAL "cxx")
        cmaize_add_cxx_executable(_cae_tgt_obj
            "${_cae_tgt_name}"
            ${_cae_UNPARSED_ARGUMENTS}
        )
    elseif()
        cpp_raise(
            InvalidBuildLanguage
            "Invalid build language: ${_cae_LANGUAGE}"
        )
    endif()

    cpp_get_global(_cae_project CMAIZE_TOP_PROJECT)

    CMaizeProject(add_target
        "${_cae_project}" "${_cae_tgt_name}" "${_cae_tgt_obj}"
    )
    CMaizeProject(add_language "${_cae_project}" "${_cae_LANGUAGE}")

    # Build the install location for this library based on the project name.
    # Note that this is overwritten if cmaize_find_or_build_dependency()
    # is building this target.
    cpp_get_global(_cae_proj CMAIZE_PROJECT_${PROJECT_NAME})
    CMaizeProject(GET "${_cae_proj}" _cae_proj_name name)
    set(
        _cae_install_path
        "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_BINDIR}/${_cae_proj_name}"
    )
    CMaizeTarget(SET "${_cae_tgt_obj}" install_path "${_cae_install_path}")
    CMaizeTarget(SET_PROPERTY
        "${_cae_tgt_obj}"
        INSTALL_PATH "${_cae_install_path}"
    )

    # Loop over each dependency. This is currently done by looking
    # up the dependencies by name from the CMaizeProject, but later
    # we should make each CMaize target hold references to its
    # dependencies
    cpp_get_global(_cae_top_proj CMAIZE_TOP_PROJECT)
    BuildTarget(GET "${_cae_tgt_obj}" _dep_list depends)
    foreach(dependency ${_dep_list})
        # Fetch the dependency's target object
        CMaizeProject(get_target
            "${_cae_top_proj}" _dep_tgt_obj "${dependency}"
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
            "${_cae_destination_prefix}/${CMAKE_INSTALL_LIBDIR}/${_cae_pkg_name}"
            _cae_lib_path
            BASE_DIRECTORY "${CMAKE_INSTALL_PREFIX}"
        )
        # Replace install prefix with $ORIGIN
        # We currently don't do this since we couldn't get it to work
        # string(REPLACE "${_cae_lib_path}" "$ORIGIN" _dep_install_path "${_dep_install_path}")

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
        CMaizeTarget(get_property "${_cae_tgt_obj}" _install_rpath INSTALL_RPATH)
        list(APPEND _install_rpath ${_dep_install_path})
        list(APPEND _install_rpath ${_dep_install_rpath})
        CMaizeTarget(set_property "${_cae_tgt_obj}" INSTALL_RPATH "${_install_rpath}")
    endforeach()

endfunction()

#[[[
# User function to build a CXX executable target.
#
# .. note::
#
#    See ``CXXTarget(make_target`` documentation for additional optional
#    arguments.
#
# :param _cace_tgt_obj: Returned target object created.
# :type _cace_tgt_obj: BuildTarget
# :param _cace_tgt_name: Name of the target to be created.
# :type _cace_tgt_name: desc
# :param SOURCE_DIR: Directory containing source code.
# :type SOURCE_DIR: path, optional
# :param INCLUDE_DIRS: Directories containing files to include.
# :type INCLUDE_DIRS: List[path], optional
# :param SOURCE_EXTS: Source file extensions (exclude the dot), defaults
#                     to the value of ``CMAKE_CXX_SOURCE_FILE_EXTENSIONS``.
# :type SOURCE_EXTS: List[desc], optional
# :param INCLUDE_EXTS: Include file extensions (exclude the dot), defaults
#                      to the value of ``CMAIZE_CXX_INCLUDE_FILE_EXTENSIONS``.
# :type INCLUDE_EXTS: List[desc], optional
#
# :returns: CXX executable target object.
# :rtype: BuildTarget
#]]
function(cmaize_add_cxx_executable _cace_tgt_obj _cace_tgt_name)
    set(_cace_one_value_args SOURCE_DIR)
    set(_cace_multi_value_args INCLUDE_DIRS SOURCE_EXTS INCLUDE_EXTS DEPENDS)

    cmake_parse_arguments(
        _cace "" "${_cace_one_value_args}" "${_cace_multi_value_args}" ${ARGN}
    )

    # Determines if the user gave custom source file extensions, otherwise
    # defaulting to CMAKE_CXX_SOURCE_FILE_EXTENSIONS
    list(LENGTH _cace_SOURCE_EXTS _cace_SOURCE_EXTS_n)
    if(NOT "${_cace_SOURCE_EXTS_n}" GREATER 0)
        set(_cace_SOURCE_EXTS "${CMAKE_CXX_SOURCE_FILE_EXTENSIONS}")
    endif()

    # Determines if the user gave custom include file extensions, otherwise
    # defaulting to CMAIZE_CXX_INCLUDE_FILE_EXTENSIONS
    list(LENGTH _cace_INCLUDE_EXTS _cace_INCLUDE_EXTS_n)
    if(NOT "${_cace_INCLUDE_EXTS_n}" GREATER 0)
        cpp_get_global(_cacl_INCLUDE_EXTS CMAIZE_CXX_INCLUDE_FILE_EXTENSIONS)
    endif()

    _cmaize_glob_files(_cace_source_files "${_cace_SOURCE_DIR}" "${_cace_SOURCE_EXTS}")
    _cmaize_glob_files(_cace_include_files "${_cace_INCLUDE_DIRS}" "${_cace_INCLUDE_EXTS}")

    CXXExecutable(CTOR _cace_exe_obj "${_cace_tgt_name}")

    CXXExecutable(make_target
        "${_cace_exe_obj}"
        INCLUDES "${_cace_include_files}"
        INCLUDE_DIRS "${_cace_INCLUDE_DIRS}"
        SOURCES "${_cace_source_files}"
        SOURCE_DIR "${_cace_SOURCE_DIR}"
        DEPENDS "${_cace_DEPENDS}"
        ${_cace_UNPARSED_ARGUMENTS}
    )

    set("${_cace_tgt_obj}" "${_cace_exe_obj}")

    cpp_return("${_cace_tgt_obj}")

endfunction()
