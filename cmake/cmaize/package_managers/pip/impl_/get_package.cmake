include_guard()

macro(_pip_get_package self _gp_result _gp_proj_specs)

    PIP(find_installed "${self}" "${_gp_result}" "${_gp_proj_specs}")

    if(NOT "${_gp_result}")
        PackageSpecification(GET "${_gp_proj_specs}" _gp_name name)
        message(FATAL_ERROR "Unable to locate Python module: ${_gp_name}")
    endif()

    cpp_return("${_gp_result}")

endmacro()
