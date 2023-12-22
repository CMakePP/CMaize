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
include(cmaize/user_api/dependencies/find_dependency)
include(cmaize/user_api/dependencies/impl_/get_package_manager)
include(cmaize/utilities/python)

ct_add_test(NAME "cmaize_find_dependency")
function("${cmaize_find_dependency}")

    # Create a project
    set(proj_name "test_find_dependency")
    project("${proj_name}")
    cmaize_project("${proj_name}")
    cpp_get_global(proj_obj CMAIZE_TOP_PROJECT)

    find_python(py_exe py_version)
    create_virtual_env(
        venv_dir "${py_exe}" "${CMAKE_BINARY_DIR}" "${cmaize_find_dependency}"
    )

    # Make sure everything is using the venv Python
    set(Python3_EXECUTABLE "${venv_dir}/bin/python3")

    ct_add_section(NAME "find_installed_package")
    function("${find_installed_package}")

        # Create the specification for CMinx
        PackageSpecification(CTOR cminx_corr)
        PackageSpecification(SET "${cminx_corr}" name "cminx")

        # Install CMinx
        _fob_get_package_manager(pm "${proj_obj}" "pip")
        PackageManager(install_package "${pm}" "${cminx_corr}")

        # Look for CMinx
        cmaize_find_dependency("cminx" PACKAGE_MANAGER pip)

        # Should have added a target to the project
        CMaizeProject(check_target "${proj_obj}" cminx_found "cminx" INSTALLED)
        ct_assert_true(cminx_found)

    endfunction()


    ct_add_section(NAME "find_not_installed_package" EXPECTFAIL)
    function("${find_not_installed_package}")

        cmaize_find_dependency("not_real" PACKAGE_MANAGER pip)

    endfunction()
endfunction()
