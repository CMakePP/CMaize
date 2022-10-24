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

    # TODO: Turn this into a function that adds package managers as they
    #       are encountered, instead of right at the beginning
    CMaizeProject(GET "${_cp_project}" _cp_pms package_managers)
    CMakePackageManager(CTOR _cp_cmake_pm)
    list(APPEND _cp_pms "${_cp_cmake_pm}")
    CMaizeProject(SET "${_cp_project}" package_managers "${_cp_pms}")

    cpp_set_global(CMAIZE_PROJECT_${PROJECT_NAME} "${_cp_project}")

endmacro()
