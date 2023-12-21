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
ct_add_test(NAME "test_cmake_package_manager")
function("${test_cmake_package_manager}")
    include(cmaize/package_managers/cmake/cmake)
    include(cmaize/project/package_specification)

    ct_add_section(NAME "type_is_cmake")
    function("${type_is_cmake}")

        set(corr "cmake")

        CMakePackageManager(CTOR pm_obj)

        CMakePackageManager(GET "${pm_obj}" _type type)

        ct_assert_equal(corr "${_type}")

    endfunction()

    ct_add_section(NAME "can_add_single_path")
    function("${can_add_single_path}")

        set(corr "/some/path")

        CMakePackageManager(CTOR pm_obj)

        CMakePackageManager(add_paths "${pm_obj}" "/some/path")

        CMakePackageManager(GET "${pm_obj}" _search_paths search_paths)

        ct_assert_equal(corr "${_search_paths}")

    endfunction()

    ct_add_section(NAME "can_add_multiple_paths")
    function("${can_add_multiple_paths}")

        ct_add_section(NAME "as_separate_elements")
        function("${as_separate_elements}")

            list(APPEND corr "/some/path")
            list(APPEND corr "/another/path")

            CMakePackageManager(CTOR pm_obj)

            CMakePackageManager(add_paths
                "${pm_obj}"
                "/some/path" "/another/path"
            )

            CMakePackageManager(GET "${pm_obj}" _search_paths search_paths)

            ct_assert_equal(corr "${_search_paths}")

        endfunction()

        ct_add_section(NAME "with_mixed_list_and_elements")
        function("${with_mixed_list_and_elements}")

            list(APPEND corr "/some/path")
            list(APPEND corr "/another/path")
            list(APPEND corr "/a/third/path")

            list(APPEND test "/some/path")
            list(APPEND test "/another/path")

            CMakePackageManager(CTOR pm_obj)

            CMakePackageManager(add_paths
                "${pm_obj}"
                "${test}"
                "/a/third/path"
            )

            CMakePackageManager(GET "${pm_obj}" _search_paths search_paths)

            ct_assert_equal(corr "${_search_paths}")

        endfunction()

        ct_add_section(NAME "with_duplicates")
        function("${with_duplicates}")

            list(APPEND corr "/some/path")
            list(APPEND corr "/another/path")

            CMakePackageManager(CTOR pm_obj)

            CMakePackageManager(add_paths
                "${pm_obj}"
                "/some/path;/another/path;/another/path"
            )

            CMakePackageManager(GET "${pm_obj}" _search_paths search_paths)

            ct_assert_equal(corr "${_search_paths}")

        endfunction()

    endfunction()

    #[[[
    # This test does assume that Git is installed on the system, which is
    # not guaranteed. It is commented out except for manual testing.
    #]]
    # ct_add_section(NAME "can_find_git")
    # function("${can_find_git}")

    #     PackageSpecification(CTOR ps_obj)
    #     PackageSpecification(SET "${ps_obj}" name "Git")
    #     PackageSpecification(SET "${ps_obj}" version "2.17.1")

    #     CMakePackageManager(CTOR pm_obj)

    #     CMakePackageManager(has_package "${pm_obj}" result "${ps_obj}")

    #     ct_assert_equal(result TRUE)

    # endfunction()

    # ct_add_section(NAME "can_find_git")
    # function("${can_find_git}")

    #     PackageSpecification(CTOR ps_obj)
    #     PackageSpecification(SET "${ps_obj}" name "utilities")

    #     CMakePackageManager(CTOR pm_obj)
    #     CMakePackageManager(add_paths "${pm_obj}" "/home/zachcran/programs/cmakepp_workspace/test_repos/nwx_utilities/install")

    #     CMakePackageManager(has_package "${pm_obj}" result "${ps_obj}")
    #     CMakePackageManager(has_package "${pm_obj}" result "${ps_obj}")

    #     message(DEBUG "utilities_FOUND: ${utilities_FOUND}")

    #     ct_assert_equal(FALSE TRUE)

    # endfunction()

endfunction()
