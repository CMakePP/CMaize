include_guard()

include(cmakepp_lang/cmakepp_lang)
include(cmaize/project/project)
include(cmaize/package_managers/package_managers)

#[[[
# Add a dependency to the project.
#
# .. warning::
# 
#    ``cpp_find_or_build_dependency()`` is depricated.
#    ``cmaize_find_or_build_dependency()`` should be used to add a dependency
#    to the project.
#
# :param _fobd_name: Name of the dependency.
# :type _fobd_name: desc
# :param **kwargs: Additional keyword arguments may be necessary.
#]]
function(cpp_find_or_build_dependency _fobd_name)

    # Forward all arguments to the new API call
    cmaize_find_or_build_dependency("${_fobd_name}" ${ARGN})

endfunction()

#[[[
# Add a dependency to the project.
#
# TODO: Add more versioning options, such as an ``EXACT`` keyword to allow
#       the user to specify that only the given version should be found.
#       As it stands, it finds any version or the exact version if ``VERSION`` is given.
#       I propose providing the following options: 1) any available version if no version
#       keyword is given; 2) the provided version, or greater; or 3) the exact
#       version if both ``VERSION`` and ``EXACT`` are provided.
#
# :param _fobdc_name: Name of the dependency.
# :type _fobdc_name: desc
# :param **kwargs: Additional keyword arguments may be necessary.
#
# :Keyword Arguments:
#    * **VERSION** (*desc*) --
#      Version of the project to find. Defaults to no version ("").
#    * **PACKAGE_MANAGER** (*desc*) --
#      Package manager to use. Must be a valid package listed in the
#      ``CMAIZE_SUPPORTED_PACKAGE_MANAGERS`` variable. Defaults to "CMake".
#]]
function(cmaize_find_or_build_dependency _fobdc_name)

    set(_fobdc_options PACKAGE_MANAGER)
    cmake_parse_arguments(_fobd "" "${_fobdc_options}" "" ${ARGN})

    # Default to CMake package manager if none were given
    if("${_fobdc_PACKAGE_MANAGER}" STREQUAL "")
        set(_fobdc_PACKAGE_MANAGER "CMake")
    endif()

    # Decide which language we are building for
    string(TOLOWER "${_fobdc_PACKAGE_MANAGER}" _fobdc_PACKAGE_MANAGER_lower)
    set(pm_obj "")
    if("${_fobdc_PACKAGE_MANAGER_lower}" STREQUAL "cmake")
        cmaize_find_or_build_dependency_cmake(
            "${_fobdc_name}"
            ${ARGN}
        )
    elseif()
        set(msg "Invalid Package Manager: ${_fobdc_PACKAGE_MANAGER}. See ")
        string(APPEND msg "CMAIZE_SUPPORTED_PACKAGE_MANAGERS for a list of")
        string(APPEND msg "supported package manager strings.")
        cpp_raise(
            InvalidPackageManager 
            "${msg}"
        )
    endif()

endfunction()

#[[[
# User function to find an installed package or fetch and build the package
# using CMake as the package management system.
#
# This means that tools such as ``find_package`` and ``FetchContent`` built
# into CMake will be used to manage packages while using this method.
#
# :param _fobdc_name: Name of the dependency to find or build.
# :type _fobdc_name: desc
# :param **kwargs: Additional keyword arguments may be necessary.
#]]
function(cmaize_find_or_build_dependency_cmake _fobdc_name)

    cmake_parse_arguments(_fobdc "" "VERSION" "" ${ARGN})

    cpp_get_global(_fobdc_project CMAIZE_PROJECT_${PROJECT_NAME})

    # Create the project specification
    ProjectSpecification(ctor _fobdc_project_specs)
    ProjectSpecification(SET "${_fobdc_project_specs}" name "${_fobdc_name}")
    ProjectSpecification(set_version "${_fobdc_project_specs}" "${_fobdc_VERSION}")

    # Add a CMakePackageManager to the project if it does not exist yet
    CMaizeProject(get_package_manager "${_fobdc_project}" _fobdc_pm "CMake")
    if("${_fobdc_pm}" STREQUAL "")
        CMakePackageManager(ctor _fobdc_pm)
        CMaizeProject(add_package_manager "${_fobdc_project}" "${_fobdc_pm}")
    endif()

    # Check if the package is already installed
    CMakePackageManager(find_installed
        "${_fobdc_pm}"
        _fobdc_tgt
        "${_fobdc_project_specs}"
        ${ARGN}
    )
    if(NOT "${_fobdc_tgt}" STREQUAL "")
        CMaizeProject(add_target
            "${_fobdc_project}" "${_fobdc_name}" "${_fobdc_tgt}" INSTALLED
        )
        cpp_return("")
    endif()

    # Prepare to build the package
    CMakePackageManager(get_package
        "${_fobdc_pm}"
        _fobdc_tgt
        "${_fobdc_project_specs}"
        ${ARGN}
    )
    if(NOT "${_fobdc_tgt}" STREQUAL "")
        CMaizeProject(add_target "${_fobdc_project}" "${_fobdc_tgt}")
        cpp_return("")
    endif()

endfunction()
