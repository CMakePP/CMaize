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

function(make_venv _mv_name)

endfunction()

ct_add_test(NAME "test_pip")
function("${test_pip}")
    include(cmaize/package_managers/pip/pip)

    # Find Python, create a new venv named with the function's unique name
    find_package(Python3 COMPONENTS Interpreter QUIET REQUIRED)
    execute_process(
        COMMAND "${Python3_EXECUTABLE}" "-m" "venv" "${test_pip}"
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    )

    # This is the Python interpreter associated with the environment we created
    # as long as we use it, packages get installed into the venv (even if we
    # don't activate the environment (which CMake makes difficult to do by
    # piping commands in execute_process))
    set(py_exe "${CMAKE_CURRENT_SOURCE_DIR}/${test_pip}/bin/python3")

    PIP(CTOR pip_pm "${py_exe}")

    # For testing purposes we'll want a package which exists on PyPI and one
    # that does note. For the former we use CMinx. For the latter we use
    # "not_the_cminx_package" and hope that no one ever actually adds a package
    # with that name to PyPI
    PackageSpecification(CTOR cminx)
    PackageSpecification(SET "${cminx}" name "cminx")

    PackageSpecification(CTOR not_real)
    PackageSpecification(SET "${not_real}" name "not_the_cminx_package")

    # Verify CMinx isn't already installed
    ct_add_section(NAME "CMinx_is_not_preinstalled")
    function("${CMinx_is_not_preinstalled}")

        PIP(find_installed "${pip_pm}" has_cminx "${cminx}")
        ct_assert_equal(has_cminx "")

    endfunction()

    # Install it (checking that it was installed happens in find_installed)
    PIP(install_package "${pip_pm}" "cminx")

    ct_add_section(NAME "find_installed")
    function("${find_installed}")

        # Look for non-existant (and thus not installed) package
        PIP(find_installed "${pip_pm}" has_not_real "${not_real}")
        ct_assert_equal(has_not_real "")

        # Look for cminx, which we pre-installed
        PIP(find_installed "${pip_pm}" has_cminx "${cminx}")
        ct_assert_equal(has_cminx "cminx")

    endfunction()

    ct_add_section(NAME "get_package")
    function("${get_package}")

        ct_add_section(NAME "package_does_not_exist" EXPECTFAIL)
        function("${package_does_not_exist}")

            PIP(get_package "${pip_pm}" the_package "${not_real}")

        endfunction()

        ct_add_section(NAME "package_does_exist")
        function("${package_does_exist}")

            PIP(get_package "${pip_pm}" the_package "${cminx}")
            ct_assert_equal(the_package "cminx")

        endfunction()

    endfunction()


    ct_add_section(NAME "comparisons")
    function("${comparisons}")

        ct_add_section(NAME "same_state")
        function("${same_state}")
            PIP(CTOR another_pm "${py_exe}")
            PIP(EQUAL "${another_pm}" are_equal "${pip_pm}")
            ct_assert_true(are_equal)
        endfunction()


        ct_add_section(NAME "different_interpreter")
        function("${different_interpreter}")
            # n.b., as long as we don't call any
            # methods that needs the interpreter any path should work)
            PIP(CTOR another_pm "/not/a/real/path")
            PIP(EQUAL "${another_pm}" are_equal "${pip_pm}")
            ct_assert_false(are_equal)
        endfunction()

    endfunction()
endfunction()
