include_guard()

include(cmakepp_lang/cmakepp_lang)
include(cmaize/project/project)
include(cmaize/package_managers/package_managers)

#[[[
# Creates a CMaize project and the underlying CMake project.
#
# :param _cp_name: Name for the project, must be unique and conform to rules
#                  of a CMake project name.
# :type _cp_name: desc
#]]
macro(cmaize_project _cp_name)

    CMaizeProject(CTOR _cp_project "${_cp_name}" ${ARGN})

    cpp_set_global(CMAIZE_PROJECT "${_cp_project}")
    cpp_set_global(CMAIZE_PROJECT_${PROJECT_NAME} "${_cp_project}")

    # Set the top-level CMaize project
    cpp_get_global(_cp_top_project CMAIZE_TOP_PROJECT)
    if("${_cp_top_project}" STREQUAL "")
        message(DEBUG "Setting ${_cp_name} as the top-level CMaize project")
        cpp_set_global(CMAIZE_TOP_PROJECT "${_cp_project}")
    endif()

endmacro()
