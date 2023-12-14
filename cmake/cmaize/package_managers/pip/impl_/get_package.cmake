include_guard()

macro(_pip_get_package self _gp_result _gp_package_specs)

    PIPPackageManager(find_installed "${self}" "${_gp_result}" "${_gp_package_specs}")

    if("${_gp_result}" STREQUAL "")
        PackageSpecification(GET "${_gp_package_specs}" _gp_name name)
        cpp_raise(
            PACKAGE_NOT_FOUND "Unable to locate Python module: ${_gp_name}"
        )
    endif()

    cpp_return("${_gp_result}")

endmacro()
