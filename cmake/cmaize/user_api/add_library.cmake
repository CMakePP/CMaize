include_guard()
include(cmakepp_lang/cmakepp_lang)
include(cmaize/targets/targets)
include(cmaize/utilities/glob_files)

#[[[
# User function to build a library target.
#
# .. warning::
# 
#    ``cpp_add_library()`` is depricated. ``cmaize_add_library()`` should
#    be used to create libraries.
#
# :param _cal_tgt_name: Name of the target to be created.
# :type _cal_tgt_name: desc
# :param INCLUDE_DIR: Directories containing files to include.
# :type INCLUDE_DIR: path, optional
#]]
function(cpp_add_library _cal_tgt_name)

    set(_cal_options INCLUDE_DIR INCLUDE_DIRS)
    cmake_parse_arguments(_cal "" "${_cal_options}" "" ${ARGN})

    # Historically, only INCLUDE_DIR was used, so INCLUDE_DIRS needs to
    # be generated based on the value of INCLUDE_DIR. If INCLUDE_DIRS is
    # provided, INCLUDE_DIR is ignored.
    list(LENGTH _cal_INCLUDE_DIRS _cal_INCLUDE_DIRS_n)
    if(NOT "${_cal_INCLUDE_DIRS_n}" GREATER 0)
        set(_cal_INCLUDE_DIRS "${_cal_INCLUDE_DIR}")
    endif()

    # Forward all arguments to the new API call
    cmaize_add_library(
        "${_cal_tgt_name}" 
        INCLUDE_DIRS "${_cal_INCLUDE_DIRS}"
        ${ARGN}
    )

endfunction()

#[[[
# User function to build a library target.
#
# .. note::
#
#    For additional optional parameters related to the specific language
#    used, see the documentation for `cmaize_add_<LANGUAGE>_library()`,
#    where `<LANGUAGE>` is the language being used.
#
# :param _cal_tgt_name: Name of the target to be created.
# :type _cal_tgt_name: desc
# :param LANGUAGE: Build language for the target, defaults to "CXX"
# :type LANGUAGE: desc, optional
#]]
function(cmaize_add_library _cal_tgt_name)

    set(_cal_options LANGUAGE)
    cmake_parse_arguments(_cal "" "${_cal_options}" "" ${ARGN})

    # Default to CXX if no language is given
    if("${_cal_LANGUAGE}" STREQUAL "")
        set(_cal_LANGUAGE "CXX")
    endif()

    # Decide which language we are building for
    string(TOLOWER "${_cal_LANGUAGE}" _cal_LANGUAGE)
    if("${_cal_LANGUAGE}" STREQUAL "cxx" OR "${_cal_LANGUAGE}" STREQUAL "")
        cmaize_add_cxx_library(
            "${_cal_tgt_name}"
            ${ARGN}
        )
    elseif()
        cpp_raise(
            InvalidBuildLanguage 
            "Invalid build language: ${_cal_language}"
        )
    endif()

endfunction()

#[[[
# User function to build a CXX library target.
#
# :param _cal_tgt_name: Name of the target to be created.
# :type _cal_tgt_name: desc
# :param SOURCE_DIR: Directory containing source code.
# :type SOURCE_DIR: path, optional
# :param INCLUDE_DIRS: Directories containing files to include.
# :type INCLUDE_DIRS: path, optional
#]]
function(cmaize_add_cxx_library _cacl_tgt_name)
    set(_cacl_options SOURCE_DIR INCLUDE_DIRS)

    cmake_parse_arguments(_cacl "" "${_cacl_options}" "" ${ARGN})

    _cmaize_glob_files(_cacl_source_files "${_cacl_SOURCE_DIR}" "cpp")
    _cmaize_glob_files(_cacl_include_files "${_cacl_INCLUDE_DIRS}" "hpp")

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
        SOURCES "${_cacl_source_files}"
        ${ARGN}
    )

endfunction()
