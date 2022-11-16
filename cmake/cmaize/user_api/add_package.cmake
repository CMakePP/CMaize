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

    string(TOLOWER "${_cap_PACKAGE_MANAGER}" _cap_pm_lower)
    if("${_cap_pm_lower}" STREQUAL "cmake")
        cmaize_add_package_cmake("${_cap_tgt_name}" ${_cap_UNPARSED_ARGUMENTS})
    else()
        cpp_raise(
            InvalidPackageManager 
            "Invalid package manager: ${_cap_PACKAGE_MANAGER}"
        )
    endif()

endfunction()

#[[[
# User function to install a CMake package.
#
# :param _capc_tgt_name: Name of the target to be installed.
# :type _capc_tgt_name: desc
#]]
function(cmaize_add_package_cmake _capc_tgt_name)

    get_package_manager(_capc_pm_obj "${_capc_tgt_name}")

    # Create new package manager if it doesn't exist
    if("${_capc_pm_obj}" STREQUAL "")
        CMakePackageManager(CTOR _capc_pm_obj)

        cpp_get_global(_capc_proj CMAIZE_PROJECT_${PROJECT_NAME})        
        CMaizeProject(add_package_manager "${_capc_proj}" "${_capc_pm_obj}")
    endif()

    # Get the build targets from the project
    cpp_get_global(_capc_proj CMAIZE_PROJECT_${PROJECT_NAME})
    CMaizeProject(GET "${_capc_proj}" tgt_list build_targets)

    # Search for the correct target to package
    foreach(tgt_i ${tgt_list})
        Target(target "${tgt_i}" _capc_name)
        if("${_capc_name}" STREQUAL "${_capc_tgt_name}")
            PackageManager(install_package
                "${_capc_pm_obj}"
                "${tgt_i}"
                ${ARGN}
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
function(get_package_manager _gpm_return_pm _gpm_type)

    # Get the list of package managers from the current project
    cpp_get_global(_gpm_proj CMAIZE_PROJECT_${PROJECT_NAME})

    # Search for the package manager in the project
    CMaizeProject(GET "${_gpm_proj}" _gpm_pm_list package_managers)
    set(_gpm_return_pm "")
    foreach(_gpm_pm_i ${_gpm_pm_list})
        PackageManager(GET "${_gpm_pm_i}" _gpm_pm_i_type type)

        # If found, return the package manager
        if("${_gpm_pm_i_type}" STREQUAL "${_gpm_type}")
            set(_gpm_return_pm "${_gpm_pm_i}")
            cpp_return("${_gpm_return_pm}")
        endif()
    endforeach()

    set(_gpm_return_pm "")
    cpp_return("${_gpm_return_pm}")

endfunction()
