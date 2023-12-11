include_guard()

include(cmaize/package_managers/pip/impl_/impl_)

cpp_class(PIPVenv PackageManager)

    #[[[
    # :type: path
    #
    # This package manager installs packages into a virtual environment. This
    # variable can be used to control the name of that virtual environment.
    #]]
    cpp_attr(PIPVenv venv_name)

    #[[[
    # :type: path
    #
    # The Python executable to use. This can range from literally just "python",
    # to a relative path, to an absolute path.
    #]]
    cpp_attr(PIPVenv python_executable)

    cpp_constructor(CTOR PIPVenv)
    function("${CTOR}" self _venv_name)

        PIPVenv(SET "${self}" venv_name "${_venv_name}")

    endfunction()

    cpp_member(find_installed PIPVenv desc PackageSpecification args)
    function("${find_installed}" self _fi_result _fi_package_specs)

        _pipv_find_installed(
            "${self}" "${_fi_result}" "${_fi_package_specs}" ${ARGN}
        )

    endfunction()

    cpp_member(get_package PIPVenv str PackageSpecification args)
    function("${get_package}" self _gp_result _gp_proj_specs)

        _pipv_get_package("${self}" "${_gp_result}" "${_gp_proj_specs}" ${ARGN})

    endfunction()

    cpp_member(install_package PIPVenv str args)
    function("${install_package}" self _ip_pkg_name)

        _pipv_install_package("${self}" "${_ip_pkg_name}" ${ARGN})

    endfunction()


cpp_end_class()

function(_register_package_manager_pip_venv)

    PIPVenv(CTOR __package_manager "venv")
    register_package_manager("pip" "${__package_manager}")

endfunction()

_register_package_manager_pip_venv()
