include_guard()
include(cmakepp_lang/cmakepp_lang)
include(cmaize/targets/targets)

#[[[
# User function to build a executable target. ``cpp_add_executable()`` is
# depricated and ``cmaize_add_executable()`` should be used to create
# executables.
#
# :param _cal_tgt_name: Name of the target to be created.
# :type _cal_tgt_name: desc
# :param LANGUAGE: Build language for the target, defaults to "CXX"
# :type LANGUAGE: desc, optional
#]]
function(cpp_add_executable _cal_tgt_name)

    # Forward all arguments to the new API call
    cmaize_add_executable("${_cal_tgt_name}" ${ARGN})

endfunction()

#[[[
# User function to build a executable target.
#
# :param _cae_tgt_name: Name of the target to be created.
# :type _cae_tgt_name: desc
# :param LANGUAGE: Build language for the target, defaults to "CXX"
# :type LANGUAGE: desc, optional
#]]
function(cmaize_add_executable _cae_tgt_name)

    set(_cae_options LANGUAGE INCLUDE_DIR INCLUDE_DIRS)
    cmake_parse_arguments(_cae "" "${_cae_options}" "" ${ARGN})

    # Default to CXX if no language is given
    if("${_cae_LANGUAGE}" STREQUAL "")
        set(_cae_LANGUAGE "CXX")
    endif()

    # INCLUDE_DIRS is generated to preserve the user API, which has 
    # historically only used INCLUDE_DIR
    list(LENGTH _cae_INCLUDE_DIRS _cae_INCLUDE_DIRS_n)
    if(NOT "${_cae_INCLUDE_DIRS_n}" GREATER 0)
        set(_cae_INCLUDE_DIRS "${_cae_INCLUDE_DIR}")
    endif()

    # Decide which language we are building for
    string(TOLOWER "${_cae_LANGUAGE}" _cae_LANGUAGE)
    if("${_cae_LANGUAGE}" STREQUAL "cxx" OR "${_cae_LANGUAGE}" STREQUAL "")
        cmaize_add_cxx_executable(
            "${_cae_tgt_name}"
            INCLUDE_DIRS "${_cae_INCLUDE_DIRS}"
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
# :param _cace_tgt_name: Name of the target to be created.
# :type _cace_tgt_name: desc
# :param SOURCE_DIR: Directory containing source code.
# :type SOURCE_DIR: path, optional
# :param INCLUDE_DIR: Directory containing files to include.
# :type INCLUDE_DIR: path, optional
#]]
function(cmaize_add_cxx_executable _cace_tgt_name)
    set(_cace_options SOURCE_DIR INCLUDE_DIR)

    cmake_parse_arguments(_cace "" "${_cace_options}" "" ${ARGN})

    # Get all the source files
    file(GLOB_RECURSE _cace_source_files
        LIST_DIRECTORIES false
        CONFIGURE_DEPENDS
        "${_cace_SOURCE_DIR}/*.cpp"
    )

    # Get the include files. This ``if`` statement might be able to be
    # replaced with ``cmake_path(APPEND``
    if (NOT "${_cace_INCLUDE_DIR}" STREQUAL "")
        file(GLOB_RECURSE _cace_include_files
            LIST_DIRECTORIES false
            CONFIGURE_DEPENDS
            "${_cace_INCLUDE_DIR}/*.hpp"
        )
    endif()

    CXXExecutable(CTOR _cace_lib_obj "${_cace_tgt_name}")

    CXXExecutable(make_target
        "${_cace_lib_obj}"
        INCLUDES "${_cace_include_files}"
        SOURCES "${_cace_source_files}"
        ${ARGN}
    )

endfunction()
