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

include(cmake_test/cmake_test)

#[[[
# Test the ``CMakePackageManager`` class.
#]]
ct_add_test(NAME "test_get_package_manager")
function("${test_get_package_manager}")
    include(cmakepp_lang/cmakepp_lang)
    include(cmaize/package_managers/get_package_manager)
    include(cmaize/package_managers/package_manager)

    ct_add_section(NAME "invalid_instance" EXPECTFAIL)
    function("${invalid_instance}")

        get_package_manager_instance(_ii_result "invalid")

    endfunction()

    ct_add_section(NAME "existing_instance")
    function("${existing_instance}")

        PackageManager(CTOR _ei_instance)
        cpp_get_global(_ei_pm_map __CMAIZE_PACKAGE_MANAGER_MAP__)

        cpp_map(SET "${_ei_pm_map}" "packagemanager" "${_ei_instance}")

        get_package_manager_instance(_ei_result "packagemanager")

        ct_assert_equal(_ei_instance "${_ei_result}")

    endfunction()

    ct_add_section(NAME "nonexistant_instance")
    function("${nonexistant_instance}")

        get_package_manager_instance(_ni_result "packagemanager")

        PackageManager(GET "${_ni_result}" _ni_type type)

        ct_assert_equal(_ni_type "None")

    endfunction()

    ct_add_section(NAME "two_of_same_instance")
    function("${two_of_same_instance}")

        get_package_manager_instance(_ni_result_1 "packagemanager")
        get_package_manager_instance(_ni_result_2 "packagemanager")

        ct_assert_equal(_ni_result_1 "${_ni_result_2}")

    endfunction()

endfunction()
