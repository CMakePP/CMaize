include_guard()
include(cmakepp_lang/cmakepp_lang)
include(cmaize/targets/targets)

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
# :param INCLUDE_DIR: Directories containing files to include.
# :type INCLUDE_DIR: path, optional
#]]
function(cpp_add_executable _cae_tgt_name)

    set(_cae_options INCLUDE_DIR INCLUDE_DIRS)
    cmake_parse_arguments(_cae "" "${_cae_options}" "" ${ARGN})

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
        ${ARGN}
    )

endfunction()

#[[[
# User function to build a executable target.
#
# .. note::
#
#    For additional optional parameters related to the specific language
#    used, see the documentation for `cmaize_add_<LANGUAGE>_executable()`,
#    where `<LANGUAGE>` is the language being used.
#
# :param _cae_tgt_name: Name of the target to be created.
# :type _cae_tgt_name: desc
# :param LANGUAGE: Build language for the target, defaults to "CXX"
# :type LANGUAGE: desc, optional
#]]
function(cmaize_add_executable _cae_tgt_name)

    set(_cae_options LANGUAGE)
    cmake_parse_arguments(_cae "" "${_cae_options}" "" ${ARGN})

    # Default to CXX if no language is given
    if("${_cae_LANGUAGE}" STREQUAL "")
        set(_cae_LANGUAGE "CXX")
    endif()

    # Decide which language we are building for
    string(TOLOWER "${_cae_LANGUAGE}" _cae_LANGUAGE)
    if("${_cae_LANGUAGE}" STREQUAL "cxx" OR "${_cae_LANGUAGE}" STREQUAL "")
        cmaize_add_cxx_executable(
            "${_cae_tgt_name}"
            ${ARGN}
        )
    elseif()
        cpp_raise(
            InvalidBuildLanguage
            "Invalid build language: ${_cae_language}"
        )
    endif()

endfunction()

#[[[
# User function to build a CXX executable target.
#
# .. note::
#    
#    See ``CXXTarget(make_target`` documentation for additional optional
#    arguments.
#
# :param _cace_tgt_name: Name of the target to be created.
# :type _cace_tgt_name: desc
# :param SOURCE_DIR: Directory containing source code.
# :type SOURCE_DIR: path, optional
# :param INCLUDE_DIRS: Directories containing files to include.
# :type INCLUDE_DIRS: path, optional
#]]
function(cmaize_add_cxx_executable _cace_tgt_name)
    set(_cace_options SOURCE_DIR INCLUDE_DIRS)

    cmake_parse_arguments(_cace "" "${_cace_options}" "" ${ARGN})

    _cmaize_glob_files(_cace_source_files "${_cace_SOURCE_DIR}" "cpp")
    _cmaize_glob_files(_cace_include_files "${_cace_INCLUDE_DIRS}" "hpp")

    CXXExecutable(CTOR _cace_lib_obj "${_cace_tgt_name}")

    CXXExecutable(make_target
        "${_cace_lib_obj}"
        INCLUDES "${_cace_include_files}"
        SOURCES "${_cace_source_files}"
        ${ARGN}
    )

endfunction()
