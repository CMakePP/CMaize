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

    CMaizeProject(CTOR _cp_project "${_cp_name}" ${ARGN})

    cpp_set_global(CMAIZE_PROJECT_${PROJECT_NAME} "${_cp_project}")

endmacro()
