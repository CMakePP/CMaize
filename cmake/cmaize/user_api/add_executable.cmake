include_guard()
include(cmakepp_lang/cmakepp_lang)
include(cmaize/targets/targets)
include(cmaize/utilities/replace_project_targets)

#[[[
# User function to build a executable target.
#
# .. warning::
#    
#    ``cpp_add_executable()`` is depricated. ``cmaize_add_executable()``
#    should be used to create executables.
#
# :param _cae_tgt_name: Name of the target to be created.
# :type _cae_tgt_name: desc
# :param INCLUDE_DIR: Directory containing files to include.
# :type INCLUDE_DIR: path, optional
# :param INCLUDE_DIRS: Directories containing files to include. If this
#                      parameter is given a value, the value of ``INCLUDE_DIR``
#                      will be ignored.
# :type INCLUDE_DIRS: List[path], optional
#]]
function(cpp_add_executable _cae_tgt_name)

    set(_cae_one_value_args INCLUDE_DIR)
    set(_cae_multi_value_args INCLUDE_DIRS)
    cmake_parse_arguments(
        _cae "" "${_cae_one_value_args}" "${_cae_multi_value_args}" ${ARGN}
    )

    # Historically, only INCLUDE_DIR was used, so INCLUDE_DIRS needs to
    # be generated based on the value of INCLUDE_DIR. If INCLUDE_DIRS is
    # provided, INCLUDE_DIR is ignored.
    list(LENGTH _cae_INCLUDE_DIRS _cae_INCLUDE_DIRS_n)
    if(NOT "${_cae_INCLUDE_DIRS_n}" GREATER 0)
        set(_cae_INCLUDE_DIRS "${_cae_INCLUDE_DIR}")
    endif()

    # Forward all arguments to the new API call
    cmaize_add_executable(
        "${_cae_tgt_name}"
        INCLUDE_DIRS "${_cae_INCLUDE_DIRS}"
        ${_cae_UNPARSED_ARGUMENTS}
    )

endfunction()

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

    message("-- DEBUG: Registering executable target: ${_cae_tgt_name}")

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

    cpp_get_global(_cae_project CMAIZE_PROJECT_${PROJECT_NAME})

    CMaizeProject(add_target
        "${_cae_project}" "${_cae_tgt_name}" "${_cae_tgt_obj}"
    )
    CMaizeProject(add_language "${_cae_project}" "${_cae_LANGUAGE}")

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
        set(_cace_INCLUDE_EXTS "${CMAIZE_CXX_INCLUDE_FILE_EXTENSIONS}")
    endif()

    _cmaize_glob_files(_cace_source_files "${_cace_SOURCE_DIR}" "${_cace_SOURCE_EXTS}")
    _cmaize_glob_files(_cace_include_files "${_cace_INCLUDE_DIRS}" "${_cace_INCLUDE_EXTS}")

    # Replace any DEPENDS values specifying CMaizeTarget objects with the
    # underlying target name
    cmaize_replace_project_targets(_cace_DEPENDS ${_cace_DEPENDS})

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
