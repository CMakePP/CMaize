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
include(cmaize/user_api/dependencies/find_optional_dependency)
include(cmaize/user_api/dependencies/impl_/get_package_manager)
include(cmaize/utilities/python)

ct_add_test(NAME "test_find_optional_dependency")
function("${test_find_optional_dependency}")

    find_python(py_exe py_version)
    create_virtual_env(
        venv_dir
        "${py_exe}"
        "${CMAKE_BINARY_DIR}"
        "${test_find_optional_dependency}"
    )

    # Make sure everything is using the venv Python
    set(Python3_EXECUTABLE "${venv_dir}/bin/python3")

    ct_add_section(NAME "is_disabled_empty")
    function("${is_disabled_empty}")

        ct_assert_target_does_not_exist(not_real_empty)

        set(ENABLE_NOT_REAL "")
        cmaize_find_optional_dependency(not_real_empty ENABLE_NOT_REAL)

        ct_assert_target_exists(not_real_empty)
        get_target_property(target_type not_real_empty TYPE)
        ct_assert_equal(target_type "INTERFACE_LIBRARY")

    endfunction()

    ct_add_section(NAME "is_disabled_false")
    function("${is_disabled_false}")

        ct_assert_target_does_not_exist(not_real_false)

        set(ENABLE_NOT_REAL FALSE)
        cmaize_find_optional_dependency(not_real_false ENABLE_NOT_REAL)

        ct_assert_target_exists(not_real_false)

        # Verify we can call the function multiple times w/o error
        cmaize_find_optional_dependency(not_real_false ENABLE_NOT_REAL)

    endfunction()

    ct_add_section(NAME "is_enabled")
    function("${is_enabled}")

        # Create a project
        set(proj_name "test_find_optional_dependency_is_enabled")
        project("${proj_name}")
        cmaize_project("${proj_name}")
        cpp_get_global(proj_obj CMAIZE_TOP_PROJECT)

        # Create the specification for CMinx
        PackageSpecification(CTOR cminx_corr)
        PackageSpecification(SET "${cminx_corr}" name "cminx")

        # Install CMinx
        _fob_get_package_manager(pm "${proj_obj}" "pip")
        PackageManager(install_package "${pm}" "${cminx_corr}")

        set(ENABLE_CMINX TRUE)

        ct_assert_target_does_not_exist(cminx)

        cmaize_find_optional_dependency(cminx ENABLE_CMINX PACKAGE_MANAGER pip)

        ct_assert_target_exists(cminx)

    endfunction()

endfunction()
