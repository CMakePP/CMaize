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
include(cmaize/utilities/python)

#[[[
# Class exposing Python's PipPackageManager package manager to CMaize.
#
# This class holds a Python interpreter and leverages the pip installation
# associated with the interpreter to locate and install pip packages.
#]]
cpp_class(PipPackageManager PackageManager)

    #[[[
    # :type: path
    #
    # The Python executable to use for running pip commands. pip invocations
    # will look like ``self.python_executable -m pip <command>``
    #]]
    cpp_attr(PipPackageManager python_executable)

    #[[[
    # Constructs a pip package manager based on the provided Python interpreter
    #
    # The PipPackageManager class works by system calling a Python interpreter.
    # When creating a PipPackageManager object the user is responsible for
    # ensuring that the Python interpreter used at creation is indeed the Python
    # interpreter that should be used for installing packages.
    #
    # :param self: The variable to assign the new object to.
    # :type self: PipPackageManager*
    # :param _py_exe: The path to the Python interpreter.
    # :type _py_exe: path
    #]]
    cpp_constructor(CTOR PipPackageManager path)
    function("${CTOR}" self _py_exe)

        PackageManager(SET "${self}" type "pip")
        PipPackageManager(SET "${self}" python_executable "${_py_exe}")

    endfunction()

    #[[[
    # Determines if self has already installed a package.
    #
    # This method will call ``pip list`` and case-insensitively ``grep`` the
    # result for the requested package. If the package is found an imported
    # interface target will be created with the provided name. Otherwise, the
    # function returns an empty string.
    #
    # :param self: The pip package manager to check for the package.
    # :type self: PipPackageManager
    # :param result: A variable to hold the result of the invocation.
    # :type result: desc
    # :param package_specs: The details pertaining to what package pip should
    #    try to find.
    # :type package_specs: PackageSpecification
    # :return: An empty string if ``package_specs`` is not already installed,
    #    otherwise a target representing the package.
    # :rtype: string or InstalledTarget
    #]]
    cpp_member(find_installed PipPackageManager desc PackageSpecification args)
    function("${find_installed}" self _fi_result _fi_package_specs)

        _pip_find_installed(
            "${self}" "${_fi_result}" "${_fi_package_specs}"
        )

    endfunction()

    #[[[
    # Retrieves an already installed package.
    #
    # This method is a convenience function for calling find_installed and
    # asserting that the result is not an empty string.
    #
    # :param self: The pip package manager to check for the pacakge.
    # :type self: PipPackageManager
    # :param result: A variable to hold the resulting target
    # :type result: InstalledTarget*
    # :param package_specs: The details of the package we are looking for.
    # :type package_specs: PackageSpecification.
    # :return: A target detailing the found package.
    # :rtype: InstalledTarget
    #
    # :raises PACKAGE_NOT_FOUND: When ``package_specs`` is not already
    #    installed.
    #]]
    cpp_member(get_package PipPackageManager str PackageSpecification args)
    function("${get_package}" self _gp_result _gp_package_specs)

        _pip_get_package(
            "${self}" "${_gp_result}" "${_gp_package_specs}" ${ARGN}
        )

    endfunction()

    #[[[
    # Installs the specified package.
    #
    # .. todo:
    #
    #    This should take a PackageSpecification and install the package during
    #    the build phase.
    #
    # This method is used to have the package manager install a package. At the
    # moment, the installation happens at configuration time.
    #
    # :param self: The package manager the package will be installed into.
    # :type self: PipPackageManager
    # :param package_specs: The specs for the package we need to install.
    # :type package_specs: PackageSpecification
    #]]
    cpp_member(install_package PipPackageManager PackageSpecification args)
    function("${install_package}" self _ip_package_specs)

        _pip_install_package("${self}" "${_ip_package_specs}" ${ARGN})

    endfunction()


cpp_end_class()

#[[[
# Enables and registers a pip package manager with the global environment.
#
# The pip package manager is only registered if "pip" has not already been
# added to the CMAIZE_SUPPORTED_PACKAGE_MANAGERS global variable.
#
# .. note::
#
#    Enabling the pip package manager adds Python as a dependency of CMaize.
#]]
function(enable_pip_package_manager)

    cpp_get_global(_eppm_pms CMAIZE_SUPPORTED_PACKAGE_MANAGERS)
    if("pip" IN_LIST _eppm_pms) # If pip is in the list, it's already enabled
        return()
    endif()

    set(_eppm_pms "${_eppm_pms}" "pip")
    cpp_set_global(CMAIZE_SUPPORTED_PACKAGE_MANAGERS "${_eppm_pms}")

    find_python(_eppm_py_exe _eppm_py_version)
    message(DEBUG "pip package manager will use Python: ${_eppm_py_exe}")

    PipPackageManager(CTOR _eppm_package_manager "${_eppm_py_exe}")
    register_package_manager("pip" "${_eppm_package_manager}")

endfunction()
