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
include(cmaize/user_api/dependencies/find_or_build_dependency)
include(cmaize/utilities/python)

#[[[
# Tests CMaize's cmaize_find_or_build_dependency function.
#
# Note, the innards of the function should be decomposed and tested
# individually.
#]]
ct_add_test(NAME "test_cmaize_find_or_build_dependency")
function("${test_cmaize_find_or_build_dependency}")

    find_python(py_exe py_version)
    create_virtual_env(
        venv_dir
        "${py_exe}"
        "${CMAKE_BINARY_DIR}"
        "${test_cmaize_find_or_build_dependency}"
    )
    set(Python3_EXECUTABLE "${venv_dir}/bin/python3")

    set(proj_name "test_cmaize_find_or_build_dependency")
    project("${proj_name}")
    cmaize_project("${proj_name}")
    cpp_get_global(proj_obj CMAIZE_TOP_PROJECT)

    ct_add_section(NAME "test_pip")
    function("${test_pip}")

        # Make what that target should look like
        set(site_pkg_dir "${venv_dir}/lib/python${py_version}/site-packages")
        InstalledTarget(CTOR corr "cminx" "${site_pkg_dir}")

        ct_add_section(NAME "not_yet_installed")
        function("${not_yet_installed}")

            cmaize_find_or_build_dependency(
                "cminx"
                PACKAGE_MANAGER "pip"
            )

            # Get the target created by cmaize_find_or_build_dependency
            CMaizeProject(get_target "${proj_obj}" cminx_tgt "cminx")

            # Compare the targets
            InstalledTarget(EQUAL "${corr}" is_same "${cminx_tgt}")
            ct_assert_true(is_same)

        endfunction()

        ct_add_section(NAME "already_installed")
        function("${already_installed}")

            cmaize_find_or_build_dependency(
                "cminx"
                PACKAGE_MANAGER "pip"
            )

            CMaizeProject(get_target "${proj_obj}" cminx_tgt "cminx")
            InstalledTarget(EQUAL "${corr}" is_same "${cminx_tgt}")
            ct_assert_true(is_same)

        endfunction()
    endfunction()

endfunction()
