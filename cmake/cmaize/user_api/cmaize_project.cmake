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

    # TODO: Potentially append or prepend a uid to the project name
    # cpp_unique_id(uid)
    # set(_cp_name "${cp_name}_${uid}")

    CMaizeProject(CTOR _cp_project "${_cp_name}" ${ARGN})

    cpp_set_global(CMAIZE_PROJECT_NAME "${_cp_name}")
    cpp_set_global("${_cp_name}_PROJECT_OBJECT" "${_cp_project}")

endmacro()
