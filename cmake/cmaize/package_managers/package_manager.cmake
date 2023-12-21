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
include(cmakepp_lang/cmakepp_lang)

include(cmaize/targets/cmaize_target)
include(cmaize/package_managers/get_package_manager)
include(cmaize/project/package_specification)

#[[[
# Base class for the PackageManager class hierarchy.
#]]
cpp_class(PackageManager)

    #[[[
    # :type: desc
    #
    # Type of the package manager being used. Defaults to "None".
    #]]
    cpp_attr(PackageManager type "None")

    #[[[
    # Virtual member to check if the package exists in the package manager.
    #]]
    cpp_member(has_package PackageManager desc PackageSpecification)
    cpp_virtual_member(has_package)

    #[[[
    # Virtual member function to get an installed package target.
    #]]
    cpp_member(find_installed PackageManager desc PackageSpecification)
    cpp_virtual_member(find_installed)

    #[[[
    # Virtual member function to get the package source and prepare a
    # build target.
    #]]
    cpp_member(get_package PackageManager desc PackageSpecification)
    cpp_virtual_member(fetch_package)

    #[[[
    # Virtual member to install a package.
    #]]
    cpp_member(install_package PackageManager str args)
    cpp_virtual_member(install_package)

cpp_end_class()

#[[[
# Registers a PackageManager instance. This should only be called at the end
# of the file defining the PackageManager class.
#]]
function(_register_package_manager_base_class)

    PackageManager(CTOR __package_manager)
    register_package_manager("packagemanager" "${__package_manager}")

endfunction()

_register_package_manager_base_class()
