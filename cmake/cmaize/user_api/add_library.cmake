include_guard()
include(cmakepp_lang/cmakepp_lang)
include(cmaize/targets/targets)

#[[[
# User function to build a library target.
#
# :param _cal_tgt_name: Name of the target to be created.
# :type _cal_tgt_name: desc
# :param LANGUAGE: Build language for the target, defaults to "CXX"
# :type LANGUAGE: desc, optional
#]]
function(cpp_add_library _cal_tgt_name)

    set(_cal_options LANGUAGE INCLUDE_DIR INCLUDE_DIRS)
    cmake_parse_arguments(_cal "" "${_cal_options}" "" ${ARGN})

    if("${_cal_LANGUAGE}" STREQUAL "")
        set(_cal_LANGUAGE "CXX")
    endif()

    # INCLUDE_DIRS is provided to preserve the user API, which has only
    # been using INCLUDE_DIR
    list(LENGTH _cal_INCLUDE_DIRS _cal_INCLUDE_DIRS_n)
    if(NOT "${_cal_INCLUDE_DIRS_n}" GREATER 0)
        set(_cal_INCLUDE_DIRS "${_cal_INCLUDE_DIR}")
    endif()

    string(TOLOWER "${_cal_LANGUAGE}" _cal_LANGUAGE)
    message("language: ${_cal_LANGUAGE}")
    if("${_cal_LANGUAGE}" STREQUAL "cxx" OR "${_cal_LANGUAGE}" STREQUAL "")
        message("Making CXX library...")
        cpp_add_cxx_library(
            "${_cal_tgt_name}"
            INCLUDE_DIRS "${_cal_INCLUDE_DIRS}"
            ${ARGN}
        )
    elseif()
        cpp_raise(InvalidBuildLanguage "Invalid build language: ${_cal_language}")
    endif()

endfunction()

#[[[
# User function to build a CXX library target.
#
# :param _cal_tgt_name: Name of the target to be created.
# :type _cal_tgt_name: desc
# :param SOURCE_DIR: Directory containing source code.
# :type SOURCE_DIR: path, optional
# :param INCLUDE_DIR: Directory containing files to include.
# :type INCLUDE_DIR: path, optional
# :param DEPENDS: Dependency target names
#]]
function(cpp_add_cxx_library _cacl_tgt_name)
    set(_cacl_options SOURCE_DIR INCLUDE_DIR)

    cmake_parse_arguments(_cacl "" "${_cacl_options}" "" ${ARGN})

    # Get all the source files
    file(GLOB_RECURSE _cacl_source_files
        LIST_DIRECTORIES false
        CONFIGURE_DEPENDS
        "${_cacl_SOURCE_DIR}/*.cpp"
    )

    # Get the include files
    file(GLOB_RECURSE _cacl_include_files
        LIST_DIRECTORIES false
        CONFIGURE_DEPENDS
        "${_cacl_INCLUDE_DIR}/*.hpp"
    )

    # Check if any source files were provided to determine if the target
    # is a library or interface library
    list(LENGTH _cacl_source_files _cacl_source_files_n)
    if("${_cacl_source_files_n}" GREATER 0)
        message("Making a CXXLibrary") # DEBUG
        CXXLibrary(CTOR _cacl_lib_obj "${_cacl_tgt_name}")
    else()
        message("Making a CXXInterfaceLibrary") # DEBUG
        CXXInterfaceLibrary(CTOR _cacl_lib_obj "${_cacl_tgt_name}")
    endif()

    CXXLibrary(make_target
        "${_cacl_lib_obj}"
        INCLUDES "${_cacl_include_files}"
        SOURCES "${_cacl_source_files}"
        ${ARGN}
    )

endfunction()
