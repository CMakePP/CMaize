include(cmake_test/cmake_test)

#[[[
# Test the ``CMakePackageManager`` class.
#]]
ct_add_test(NAME "test_cmake_package_manager")
function("${test_cmake_package_manager}")
    include(cmaize/package_managers/cmake_package_manager)

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

            CMakePackageManager(add_paths "${pm_obj}" "/some/path;/another/path")

            CMakePackageManager(GET "${pm_obj}" _search_paths search_paths)

            ct_assert_equal(corr "${_search_paths}")

        endfunction()

        ct_add_section(NAME "with_duplicates")
        function("${with_duplicates}")

            list(APPEND corr "/some/path")
            list(APPEND corr "/another/path")

            CMakePackageManager(CTOR pm_obj)

            CMakePackageManager(add_paths "${pm_obj}" "/some/path;/another/path;/another/path")

            CMakePackageManager(GET "${pm_obj}" _search_paths search_paths)

            ct_assert_equal(corr "${_search_paths}")

        endfunction()

    endfunction()

endfunction()
