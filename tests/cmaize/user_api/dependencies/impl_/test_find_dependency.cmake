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
include(cmaize/user_api/cmaize_project)
include(cmaize/user_api/dependencies/impl_/find_dependency)
include(cmaize/utilities/python)

ct_add_test(NAME "_cmaize_find_dependency")
function("${_cmaize_find_dependency}")

    # Create a project
    set(proj_name "test_cmaize_find_dependency")
    project("${proj_name}")
    cmaize_project("${proj_name}")
    cpp_get_global(proj_obj CMAIZE_TOP_PROJECT)

    find_python(py_exe py_version)
    create_virtual_env(
        venv_dir "${py_exe}" "${CMAKE_BINARY_DIR}" "${_cmaize_find_dependency}"
    )

    # Make sure everything is using the venv Python
    set(Python3_EXECUTABLE "${venv_dir}/bin/python3")

    # The corr package manager
    _fob_get_package_manager(pm_corr "${proj_obj}" "pip")

    ct_add_section(NAME "find_installed_package")
    function("${find_installed_package}")

        # Create the specification for CMinx
        PackageSpecification(CTOR cminx_corr)
        PackageSpecification(SET "${cminx_corr}" name "cminx")

        # Install CMinx
        PackageManager(install_package "${pm_corr}" "${cminx_corr}")

        # Look for CMinx
        _cmaize_find_dependency(
            cminx_tgt pm cminx "${proj_obj}" "cminx" PACKAGE_MANAGER pip
        )

        # Should get back a target since if it was found
        ct_assert_not_equal(cminx_tgt "")

        PackageManager(EQUAL "${pm_corr}" are_equal "${pm}")
        ct_assert_true(are_equal)

        PackageSpecification(EQUAL "${cminx_corr}" are_equal "${cminx}")
        ct_assert_true(are_equal)

        # Target should have been added to the project
        CMaizeProject(check_target "${proj_obj}" cminx_found "cminx" INSTALLED)
        ct_assert_true(cminx_found)

    endfunction()


    ct_add_section(NAME "find_not_installed_package")
    function("${find_not_installed_package}")

        _cmaize_find_dependency(
            not_real_tgt
            pm
            not_real
            "${proj_obj}"
            "not_real"
            VERSION 1.0.0
            PACKAGE_MANAGER pip
        )

        ct_assert_equal(not_real_tgt "")

        PackageManager(EQUAL "${pm_corr}" are_equal "${pm}")
        ct_assert_true(are_equal)

        # This is the package spec that should have been made
        PackageSpecification(CTOR not_real_corr)
        PackageSpecification(SET "${not_real_corr}" name "not_real")
        PackageSpecification(SET "${not_real_corr}" version "1.0.0")


        PackageSpecification(EQUAL "${not_real_corr}" are_equal "${not_real}")
        ct_assert_true(are_equal)

    endfunction()
endfunction()
