include_guard()

macro(_pip_install_package self _ip_pkg_name)

    PIP(GET "${self}" _ip_py_exe python_executable)

    execute_process(
        COMMAND "${_ip_py_exe}" "-m" "pip" "install" "${_ip_pkg_name}"
        OUTPUT_QUIET
    )

endmacro()
