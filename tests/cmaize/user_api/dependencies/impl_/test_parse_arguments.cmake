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
include(cmaize/user_api/dependencies/impl_/parse_arguments)

ct_add_test(NAME "_fob_parse_arguments")
function("${_fob_parse_arguments}")

    # All of these tests return the same base PackageSpec
    PackageSpecification(CTOR corr)
    PackageSpecification(SET "${corr}" name cminx)

    ct_add_section(NAME "no_extra_args")
    function("${no_extra_args}")

        _fob_parse_arguments(pkg_specs pm_name cminx)

        PackageSpecification(EQUAL "${corr}" are_equal "${pkg_specs}")
        ct_assert_true(are_equal)

        ct_assert_equal(pm_name "cmake")

    endfunction()

    ct_add_section(NAME "pass_PACKAGE_MANAGER")
    function("${pass_PACKAGE_MANAGER}")

        _fob_parse_arguments(pkg_specs pm_name cminx PACKAGE_MANAGER pip)

        PackageSpecification(EQUAL "${corr}" are_equal "${pkg_specs}")
        ct_assert_true(are_equal)

        ct_assert_equal(pm_name "pip")

    endfunction()


    ct_add_section(NAME "pass_VERSION")
    function("${pass_VERSION}")

        _fob_parse_arguments(pkg_specs pm_name cminx VERSION 1.1.1)

        PackageSpecification(SET "${corr}" version "1.1.1")
        PackageSpecification(EQUAL "${corr}" are_equal "${pkg_specs}")
        ct_assert_true(are_equal)

        ct_assert_equal(pm_name "cmake")
    endfunction()

endfunction()
