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
include(cmaize/utilities/python)

ct_add_test(NAME "test_pip")
function("${test_pip}")
    include(cmaize/package_managers/pip/pip)
    find_python(py_exe py_version)
    create_virtual_env(
        venv_dir "${py_exe}" "${CMAKE_BINARY_DIR}" "${test_pip}"
    )

    # Make sure everything is using the venv Python
    set(Python3_EXECUTABLE "${venv_dir}/bin/python3")
    enable_pip_package_manager()


    # This is the Python interpreter associated with the environment we created
    # as long as we use it, packages get installed into the venv (even if we
    # don't activate the environment (which CMake makes difficult to do by
    # piping commands in execute_process))
    set(py_exe "${venv_dir}/bin/python3")

    # This is the package manager we are going to be testing
    PipPackageManager(CTOR pip_pm "${py_exe}")

    # For testing purposes we'll want a package which exists on PyPI and one
    # that does not. For the former we use CMinx. For the latter we use
    # "not_the_cminx_package" and hope that no one ever actually adds a package
    # with that name to PyPI
    PackageSpecification(CTOR cminx)
    PackageSpecification(SET "${cminx}" name "cminx")

    PackageSpecification(CTOR not_real)
    PackageSpecification(SET "${not_real}" name "not_the_cminx_package")

    # This is the correct installed target which should be generated for cminx
    InstalledTarget(
        CTOR corr "cminx" "${venv_dir}/lib/python${py_version}/site-packages"
    )

    # Verify CMinx isn't already installed
    ct_add_section(NAME "CMinx_is_not_preinstalled")
    function("${CMinx_is_not_preinstalled}")

        PipPackageManager(find_installed "${pip_pm}" has_cminx "${cminx}")
        ct_assert_equal(has_cminx "")

    endfunction()

    ct_add_section(NAME "find_installed")
    function("${find_installed}")

        # Look for non-existant (and thus not installed) package
        PipPackageManager(find_installed "${pip_pm}" has_not_real "${not_real}")
        ct_assert_equal(has_not_real "")

        # Install and then look for cminx.
        PipPackageManager(install_package "${pip_pm}" "${cminx}")
        PipPackageManager(find_installed "${pip_pm}" cminx_tgt "${cminx}")

        InstalledTarget(EQUAL "${corr}" has_cminx "${cminx_tgt}")
        ct_assert_true(has_cminx)

    endfunction()

    ct_add_section(NAME "get_package")
    function("${get_package}")

        ct_add_section(NAME "package_does_not_exist" EXPECTFAIL)
        function("${package_does_not_exist}")

            PipPackageManager(get_package "${pip_pm}" the_package "${not_real}")

        endfunction()

        ct_add_section(NAME "package_does_exist")
        function("${package_does_exist}")

            PipPackageManager(get_package "${pip_pm}" the_package "${cminx}")
            InstalledTarget(EQUAL "${corr}" has_cminx "${the_package}")
            ct_assert_true(has_cminx)

        endfunction()

    endfunction()


    ct_add_section(NAME "comparisons")
    function("${comparisons}")

        ct_add_section(NAME "same_state")
        function("${same_state}")

            PipPackageManager(CTOR another_pm "${py_exe}")
            PipPackageManager(EQUAL "${another_pm}" are_equal "${pip_pm}")
            ct_assert_true(are_equal)

        endfunction()


        ct_add_section(NAME "different_interpreter")
        function("${different_interpreter}")

            # n.b., as long as we don't call any
            # methods that needs the interpreter any path should work)
            PipPackageManager(CTOR another_pm "/not/a/real/path")
            PipPackageManager(EQUAL "${another_pm}" are_equal "${pip_pm}")
            ct_assert_false(are_equal)

        endfunction()

    endfunction()
endfunction()
