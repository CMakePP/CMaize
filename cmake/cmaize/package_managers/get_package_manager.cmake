include_guard()
include(cmakepp_lang/cmakepp_lang)

include(cmaize/package_managers/package_manager)
include(cmaize/package_managers/cmake/cmake_package_manager)

function(get_package_manager_instance _gpmi_result _gpmi_type)
    cpp_assert_signature("${ARGV}" desc desc)

    # Lowercase the type string to homogenize it before doing any lookups
    string(TOLOWER "${_gpmi_type}" _gpmi_type_lower)

    # Look up if there is an instance of the package manager already
    cpp_get_global(
        _gpmi_instance __CMAIZE_PACKAGE_MANAGER_${_gpmi_type_lower}__
    )

    # Return early if an instance exists
    if(NOT "${_gpmi_instance}" STREQUAL "")
        set("${_gpmi_result}" "${_gpmi_instance}")
        cpp_return("${_gpmi_result}")
    endif()

    # Create an instance of the package manager
    if("${_gpmi_type_lower}" STREQUAL "packagemanager")
        PackageManager(CTOR "${_gpmi_result}")
    elseif("${_gpmi_type_lower}" STREQUAL "cmakepackagemanager")
        CMakePackageManager(CTOR "${_gpmi_result}")
    else()
        cpp_raise(
            InvalidPackageManagerType
            "Invalid package manager type: ${_gpmi_type}"
        )
    endif()

    # Store the new package manager instance
    cpp_set_global(
        __CMAIZE_PACKAGE_MANAGER_${_gpmi_type_lower}__ "${${_gpmi_result}}"
    )

    cpp_return("${_gpmi_result}")

endfunction()