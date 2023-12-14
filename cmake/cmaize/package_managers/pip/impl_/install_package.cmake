include_guard()

macro(_pip_install_package self _ip_package_specs)

    PIPPackageManager(GET "${self}" _ip_py_exe python_executable)
    PackageSpecification(GET "${_ip_package_specs}" _ip_name name)
    execute_process(
        COMMAND "${_ip_py_exe}" "-m" "pip" "install" "${_ip_name}"
        OUTPUT_QUIET
    )

endmacro()
