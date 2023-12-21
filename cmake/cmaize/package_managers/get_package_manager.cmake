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

# include(cmaize/package_managers/package_manager)
# include(cmaize/package_managers/cmake/cmake_package_manager)

# Initialize the package manager instance map
cpp_map(CTOR __pm_map)
cpp_set_global(__CMAIZE_PACKAGE_MANAGER_MAP__ "${__pm_map}")

#[[[
# Gets an existing instance or creates a new instance of a PackageManager
# object. This function should be used to ensure that only one instance
# of each PackageManager subclass can exist at a time.
#
# :param _gpmi_result: Return variable for PackageManager instance
# :type _gpmi_result: PackageManager*
# :param _gpmi_type: Package manager type to instantiate. Valid types can
#                    be found in the ``CMAIZE_SUPPORTED_PACKAGE_MANAGERS``
#                    variable. This value is case-insensitive.
# :type _gpmi_type: desc
#
# :returns: PackageManager instance
#]]
function(get_package_manager_instance _gpmi_result _gpmi_type)
    cpp_assert_signature("${ARGV}" desc desc)

    cpp_get_global(_gpmi_pm_map __CMAIZE_PACKAGE_MANAGER_MAP__)
    cpp_map(HAS_KEY "${_gpmi_pm_map}" _gpmi_has_type "${_gpmi_type}")

    if(NOT _gpmi_has_type)
        cpp_raise(
            PM_NOT_FOUND
            "Could not locate a package manager of type '${_gpmi_type}'"
        )
    endif()
    cpp_map(GET "${_gpmi_pm_map}" _gpmi_instance "${_gpmi_type}")

    if("${_gpmi_instance}" STREQUAL "")
        cpp_raise(
            InvalidPackageManagerType
            "Invalid package manager type: ${_gpmi_type}"
        )
    endif()

    set("${_gpmi_result}" "${_gpmi_instance}")
    cpp_return("${_gpmi_result}")

endfunction()

#[[[
# Stores a package manager instance to be retrieved by the
# ``get_package_manager_instance()`` function.
#]]
function(register_package_manager _rpm_name _rpm_instance)

    cpp_get_global(_rpm_pm_map __CMAIZE_PACKAGE_MANAGER_MAP__)
    cpp_map(SET "${_rpm_pm_map}" "${_rpm_name}" "${_rpm_instance}")
    cpp_set_global(__CMAIZE_PACKAGE_MANAGER_MAP__ "${_rpm_pm_map}")

endfunction()
