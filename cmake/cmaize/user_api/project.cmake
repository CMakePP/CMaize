include_guard()

include(cmakepp_lang/cmakepp_lang)
include(cmaize/project/project)

#[[[
# Creates a CMaize project and the underlying CMake project.
#
# :param _cp_name: Name for the project, must be unique and conform to rules
#                  of a CMake project name.
# :type _cp_name: desc
#]]
macro(cmaize_project _cp_name)

    set(_cp_options VERSION)
    set(_cp_lists LANGUAGES)
    cmake_parse_arguments(_cp "" "${_cal_options}" "${_cp_lists}" ${ARGN})

    CMaizeProject(CTOR
        _cp_project
        _cp_VERSION
        _cp_LANGUAGES
        _cp_UNPARSED_ARGUMENTS
    )

endmacro()
