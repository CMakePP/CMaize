include(cmake_test/cmake_test)

#[[[
# Test the ``CMakePackageManager`` class.
#]]
ct_add_test(NAME "test_cmake_package_manager")
function("${test_cmake_package_manager}")
    include(cmaize/package_managers/cmake_package_manager)
    include(cmaize/project_specification/project_specification)

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

        ct_add_section(NAME "without_duplicates")
        function("${without_duplicates}")

            list(APPEND corr "/some/path")
            list(APPEND corr "/another/path")

            CMakePackageManager(CTOR pm_obj)

            CMakePackageManager(add_paths
                "${pm_obj}"
                "/some/path;/another/path"
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

    #     ProjectSpecification(CTOR ps_obj)
    #     ProjectSpecification(SET "${ps_obj}" name "Git")
    #     ProjectSpecification(SET "${ps_obj}" version "2.17.1")

    #     CMakePackageManager(CTOR pm_obj)

    #     CMakePackageManager(has_package "${pm_obj}" result "${ps_obj}")

    #     ct_assert_equal(result TRUE)

    # endfunction()

endfunction()
