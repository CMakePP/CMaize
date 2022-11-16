include_guard()
include(cmakepp_lang/cmakepp_lang)

#[[[
# User function to install a package.
#
# :param _cap_tgt_name: Name of the target to be installed.
# :type _cap_tgt_name: desc
#
# :Keyword Arguments:
#    * **PACKAGE_MANAGER** (*desc*) --
#      Package manager to add the package to. A list of supported package
#      manager keywords can be found in ``CMAIZE_SUPPORTED_PACKAGE_MANAGERS``.
#]]
function(cmaize_add_package _cap_tgt_name)

    message("-- DEBUG: Registering install package: ${_cap_tgt_name}")

    set(_cap_options PACKAGE_MANAGER)
    cmake_parse_arguments(_cap "" "${_cap_options}" "" ${ARGN})

    if("${_cap_PACKAGE_MANAGER}" STREQUAL "")
        set(_cap_PACKAGE_MANAGER "CMake")
    endif()

    # Get the requested package manager from the project, adding a new
    # one if it does not exist in the project yet
    get_package_manager(
        _cap_pm_obj
        "${_cap_PACKAGE_MANAGER}"
    )

    # Get the build targets from the project
    cpp_get_global(_cap_proj CMAIZE_PROJECT_${PROJECT_NAME})
    CMaizeProject(GET "${_cap_proj}" tgt_list build_targets)

    # Search for the correct target to package
    foreach(tgt_i ${tgt_list})
        Target(target "${tgt_i}" _cap_name)
        if("${_cap_name}" STREQUAL "${_cap_tgt_name}")
            PackageManager(install_package
                "${_cap_pm_obj}"
                "${tgt_i}"
                ${_cap_UNPARSED_ARGUMENTS}
            )
            cpp_return("")
        endif()
    endforeach()

endfunction()

#[[[
# Get an existing package manager from the current project, or create a new
# package manager if one does not exist. This new package manager instance
# is added to the current project.
#
# :param _gpm_return_pm: Return variable for the package manager
# :type _gpm_return_pm: PackageManager*
# :param _gpm_name: Name of the type of package manager to use. Supported
#                   package manager names can be found in
#                   ``CMAIZE_SUPPORTED_PACKAGE_MANAGERS``.
# :type _gpm_name: desc
#
# :returns: Package manager of the requested type.
# :rtype: PackageManager
#]]
function(get_package_manager _gpm_return_pm _gpm_name)

    # Get the list of package managers from the current project
    cpp_get_global(_gpm_proj CMAIZE_PROJECT_${PROJECT_NAME})

    # Search for the package manager in the project
    CMaizeProject(GET "${_gpm_proj}" _gpm_pm_list package_managers)
    set(_gpm_return_pm "")
    foreach(_gpm_pm_i ${_gpm_pm_list})
        PackageManager(GET "${_gpm_pm_i}" _gpm_type type)

        # If found, return the package manager
        if("${_gpm_type}" STREQUAL "${_gpm_name}")
            set(_gpm_return_pm "${_gpm_pm_i}")
            cpp_return("${_gpm_return_pm}")
        endif()
    endforeach()

    # If the package manager doesn't exist in the project, create it
    string(TOLOWER "${_gpm_name}" _gpm_name_lower)
    if("${_gpm_name_lower}" STREQUAL "cmake")
        CMakePackageManager(CTOR _gpm_return_pm)
    else()
        cpp_raise(
            InvalidPackageManager 
            "Invalid package manager: ${_gpm_name}"
        )
    endif()

    # Add the created package manager to the project
    CMaizeProject(add_package_manager "${_gpm_proj}" "${_gpm_return_pm}")

    cpp_return("${_gpm_return_pm}")

endfunction()
