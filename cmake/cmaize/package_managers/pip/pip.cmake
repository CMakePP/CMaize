# Copyright 2023 CMakePP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_guard()

include(cmaize/package_managers/package_manager)
include(cmaize/package_managers/pip/impl_/impl_)


#[[[
# Class exposing Python's PIP package manager to CMaize.
#
#]]
cpp_class(PIP PackageManager)

    #[[[
    # :type: path
    #
    # The Python executable to use for running pip commands. Pip invocations
    # will look like ``self.python_executable -m pip <command>``
    #]]
    cpp_attr(PIP python_executable)

    #[[[
    # Constructs a PIP package manager based on the provided Python interpreter
    #
    # The PIP class works by system calling a Python interpreter. When creating
    # a PIP object the user is responsible for ensuring that the Python
    # interpreter used at creation is indeed the Python interpreter that should
    # be used for installing packages.
    #
    # :param self: The variable the newly constructed PIP object will be
    #    assigned to.
    # :type self: PIP*
    # :param _py_exe: The path to the Python interpreter.
    # :type _py_exe: path
    #]]
    cpp_constructor(CTOR PIP path)
    function("${CTOR}" self _py_exe)

        PackageManager(SET type "pip")
        PIP(SET "${self}" python_executable "${_py_exe}")

    endfunction()

    #[[[
    # Determines if self has already installed a package.
    #
    # This method will call ``pip list`` and case-insensitively ``grep`` the
    # result for the requested package. If the package is found an imported
    # interface target will be created with the provided name. Otherwise, the
    # function returns an empty string.
    #
    # :param self: The PIP package manager to check for the package.
    # :type self: PIP
    # :param result: A variable to hold the result of the invocation.
    # :type result: desc
    # :param package_specs: The details pertaining to what package PIP should
    #    try to find.
    # :type package_specs: PackageSpecification
    # :return:
    #
    #]]
    cpp_member(find_installed PIP desc PackageSpecification)
    function("${find_installed}" self _fi_result _fi_package_specs)

        _pip_find_installed(
            "${self}" "${_fi_result}" "${_fi_package_specs}"
        )

    endfunction()

    cpp_member(get_package PIP str PackageSpecification args)
    function("${get_package}" self _gp_result _gp_proj_specs)

        _pip_get_package("${self}" "${_gp_result}" "${_gp_proj_specs}" ${ARGN})

    endfunction()

    cpp_member(install_package PIP str args)
    function("${install_package}" self _ip_pkg_name)

        _pip_install_package("${self}" "${_ip_pkg_name}" ${ARGN})

    endfunction()


cpp_end_class()

function(_register_package_manager_pip)

    find_package(Python3 COMPONENTS Interpreter QUIET REQUIRED)
    PIP(CTOR __package_manager "${Python3_EXECUTABLE}")
    register_package_manager("pip" "${__package_manager}")

endfunction()

_register_package_manager_pip()
