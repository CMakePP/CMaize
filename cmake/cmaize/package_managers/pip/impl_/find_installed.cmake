include_guard()

include(cmaize/targets/installed_target)

macro(_pip_find_installed self _fi_result _fi_package_specs)

    PIP(GET "${self}" _fi_py_exe python_executable)

    # Unpack the package details we need (for now just the name)
    PackageSpecification(GET "${_fi_package_specs}" _fi_name name)

    # Ask PIP to find a package with the unpacked details. Returns an empty
    # string if package matching the details can not be found.
    execute_process(
        COMMAND "${_fi_py_exe}" "-m" "pip" "list"
        COMMAND "grep" "-iw" "${_fi_name}"
        OUTPUT_VARIABLE _fi_matching_modules
    )

    if("${_fi_matching_modules}" STREQUAL "") # Branch for package not found

        set("${_fi_result}" "" PARENT_SCOPE)

    else() # Branch for when package is found

        if(NOT TARGET "${_fi_name}")
            add_library("${_fi_name}" INTERFACE IMPORTED)
        endif()

        execute_process(
            COMMAND "${_fi_py_exe}" "-m" "pip" "show" "${_fi_name}"
            COMMAND "grep" "-w" "Location"
            OUTPUT_VARIABLE _fi_install_root
        )
        string(SUBSTRING "${_fi_install_root}" 10 -1 _fi_install_root)
        string(STRIP "${_fi_install_root}" _fi_install_root)
        message("Install root2: '${_fi_install_root}'")

        InstalledTarget(
            CTOR "${_fi_result}" "${_fi_name}" "${_fi_install_root}"
        )
        cpp_return("${_fi_result}")

    endif()

endmacro()
